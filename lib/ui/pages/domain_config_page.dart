import 'package:flutter/material.dart';
import '../services/domain_provider_service.dart';

class DomainConfigPage extends StatefulWidget {
  const DomainConfigPage({Key? key}) : super(key: key);

  @override
  State<DomainConfigPage> createState() => _DomainConfigPageState();
}

class _DomainConfigPageState extends State<DomainConfigPage> {
  final DomainProviderService _service = DomainProviderService();
  Map<String, String> _domains = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDomains();
  }

  Future<void> _loadDomains() async {
    final domains = await _service.getCustomDomains();
    setState(() {
      _domains = domains;
      _isLoading = false;
    });
  }

  void _showAddDialog() {
    final domainController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Domain'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: domainController, decoration: const InputDecoration(labelText: 'Domain (e.g., my.free.domain)')),
            TextField(controller: urlController, decoration: const InputDecoration(labelText: 'Target URL (e.g., http://192.168.1.5)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (domainController.text.isNotEmpty && urlController.text.isNotEmpty) {
                await _service.addDomain(domainController.text, urlController.text);
                _loadDomains();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free Domains & Routing')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _domains.isEmpty
              ? const Center(child: Text('No custom domains configured.'))
              : ListView.builder(
                  itemCount: _domains.length,
                  itemBuilder: (context, index) {
                    final domain = _domains.keys.elementAt(index);
                    return ListTile(
                      title: Text(domain),
                      subtitle: Text(_domains[domain]!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _service.removeDomain(domain);
                          _loadDomains();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
