import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/download_task.dart';
import '../filesystem/local_novafs.dart';

/// Manages file downloads, supporting pause, resume, and cancel.
class DownloadManager extends ChangeNotifier {
  final List<DownloadTask> _tasks = [];
  final Dio _dio = Dio();
  final LocalNovaFS _fs = LocalNovaFS();

  List<DownloadTask> get tasks => List.unmodifiable(_tasks);

  /// Starts a new download
  Future<void> startDownload(String url, String filename) async {
    // Duplicate detection
    if (_tasks.any((t) => t.url == url && t.status == DownloadStatus.downloading)) {
      return; // Already downloading
    }

    final savePath = 'novafs://Downloads/$filename';
    final physicalPath = await _fs._resolvePath(savePath); // Accessing internal method for Dio
    
    final task = DownloadTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      filename: filename,
      savePath: savePath,
      cancelToken: CancelToken(),
    );
    
    _tasks.add(task);
    notifyListeners();

    try {
      await _dio.download(
        url,
        physicalPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            task.progress = received / total;
            notifyListeners();
          }
        },
        cancelToken: task.cancelToken,
        options: Options(receiveTimeout: const Duration(minutes: 30)),
      );
      task.status = DownloadStatus.completed;
      task.progress = 1.0;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        task.status = DownloadStatus.canceled;
      } else {
        task.status = DownloadStatus.failed;
      }
    } catch (e) {
      task.status = DownloadStatus.failed;
    }
    notifyListeners();
  }

  /// Pauses an active download
  void pauseDownload(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    if (task.status == DownloadStatus.downloading) {
      task.cancelToken?.cancel('Paused by user');
      task.status = DownloadStatus.paused;
      notifyListeners();
    }
  }

  /// Resumes a paused download (Restarts from beginning for simplicity in this cycle)
  Future<void> resumeDownload(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    if (task.status == DownloadStatus.paused || task.status == DownloadStatus.failed) {
      task.status = DownloadStatus.downloading;
      task.cancelToken = CancelToken();
      notifyListeners();
      
      final physicalPath = await _fs._resolvePath(task.savePath);
      try {
        await _dio.download(
          task.url,
          physicalPath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              task.progress = received / total;
              notifyListeners();
            }
          },
          cancelToken: task.cancelToken,
        );
        task.status = DownloadStatus.completed;
        task.progress = 1.0;
      } catch (e) {
        task.status = DownloadStatus.failed;
      }
      notifyListeners();
    }
  }

  /// Cancels a download completely
  void cancelDownload(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    if (task.status == DownloadStatus.downloading) {
      task.cancelToken?.cancel('Canceled by user');
    }
    task.status = DownloadStatus.canceled;
    notifyListeners();
  }

  /// Removes a task from the list
  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
