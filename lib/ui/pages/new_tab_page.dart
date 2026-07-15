import 'package:flutter/material.dart';

class NewTabPage extends StatelessWidget {
  const NewTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nova', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search the web or type a URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: const Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  print('Navigating to: $value');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
