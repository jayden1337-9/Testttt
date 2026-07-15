import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/download_task.dart';
import '../services/download_manager.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final downloadManager = context.watch<DownloadManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: downloadManager.tasks.isEmpty
          ? const Center(child: Text('No downloads yet.'))
          : ListView.builder(
              itemCount: downloadManager.tasks.length,
              itemBuilder: (context, index) {
                final task = downloadManager.tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.filename,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: task.progress,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(task.progress * 100).toStringAsFixed(0)}% - ${task.status.name}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            _buildActionButtons(context, task, downloadManager),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildActionButtons(BuildContext context, DownloadTask task, DownloadManager manager) {
    switch (task.status) {
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () => manager.pauseDownload(task.id),
        );
      case DownloadStatus.paused:
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => manager.resumeDownload(task.id),
        );
      case DownloadStatus.completed:
      case DownloadStatus.canceled:
        return IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => manager.removeTask(task.id),
        );
    }
  }
}
