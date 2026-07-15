import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';

class FindInPageBar extends StatefulWidget {
  const FindInPageBar({Key? key}) : super(key: key);

  @override
  State<FindInPageBar> createState() => _FindInPageBarState();
}

class _FindInPageBarState extends State<FindInPageBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Find in page...',
                isDense: true,
              ),
              onSubmitted: (value) {
                context.read<TabManager>().findInPage(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.read<TabManager>().findInPage(_controller.text),
          ),
        ],
      ),
    );
  }
}
