import 'package:flutter/material.dart';
import '../filesystem/local_novafs.dart';

/// A built-in file manager for NovaFS.
class FileManagerPage extends StatefulWidget {
  final String initialPath;
  
  const FileManagerPage({Key? key, this.initialPath = 'novafs://'}) : super(key: key);

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  final LocalNovaFS _fs = LocalNovaFS();
  String _currentPath = 'novafs://';
  List<String> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.initialPath;
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    setState(() => _isLoading = true);
    try {
      // Ensure root directory exists
      if (!await _fs.exists(_currentPath)) {
        await _fs.write('novafs://Browser/.init', ''); // Force create structure
      }
      final items = await _fs.listDirectory(_currentPath);
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPath),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () {
              // TODO: Implement folder creation in Cycle 12
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder creation coming soon!')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('This folder is empty.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final itemPath = _items[index];
                    final name = itemPath.split('/').last;
                    
                    return FutureBuilder(
                      future: _fs.metadata(itemPath),
                      builder: (context, snapshot) {
                        final isDir = snapshot.data?.isDirectory ?? false;
                        return ListTile(
                          leading: Icon(isDir ? Icons.folder : Icons.insert_drive_file),
                          title: Text(name),
                          onTap: () {
                            if (isDir) {
                              setState(() {
                                _currentPath = itemPath.endsWith('/') ? itemPath : '$itemPath/';
                              });
                              _loadDirectory();
                            } else {
                              // TODO: Open file in viewer
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening $name... (Viewer coming soon)')),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
