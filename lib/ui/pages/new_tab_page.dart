import 'package:flutter/material.dart';

class NewTabPage extends StatelessWidget {
  final bool isIncognito;
  const NewTabPage({Key? key, this.isIncognito = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isIncognito ? Colors.grey[900] : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncognito ? Icons.privacy_tip : Icons.public,
              size: 64,
              color: isIncognito ? Colors.white : Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            Text(
              isIncognito ? 'Incognito Mode' : 'Nova',
              style: TextStyle(
                fontSize: 48, 
                fontWeight: FontWeight.bold,
                color: isIncognito ? Colors.white : null,
              ),
            ),
            if (isIncognito)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'You are now in Incognito Mode. Nova will not save your history, cookies, or site data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
