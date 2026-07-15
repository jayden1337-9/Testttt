import 'package:dio/dio.dart';

enum DownloadStatus { downloading, paused, completed, canceled, failed }

class DownloadTask {
  final String id;
  final String url;
  final String filename;
  final String savePath; // novafs:// path
  double progress; // 0.0 to 1.0
  DownloadStatus status;
  CancelToken? cancelToken;

  DownloadTask({
    required this.id,
    required this.url,
    required this.filename,
    required this.savePath,
    this.progress = 0.0,
    this.status = DownloadStatus.downloading,
    this.cancelToken,
  });
}
