import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../services/tab_manager.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final historyService = HistoryService();
    final history = await historyService.getHistory();
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await HistoryService().clearHistory();
              _loadHistory();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(child: Text('No history yet.'))
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return ListTile(
                      leading: const Icon(Icons.public),
                      title: Text(item['title'] ?? 'Untitled'),
                      subtitle: Text(item['url'] ?? ''),
                      onTap: () {
                        context.read<TabManager>().updateUrl(item['url']!);
                        Navigator.pop(context); // Return to browser
                      },
                    );
                  },
                ),
    );
  }
}
