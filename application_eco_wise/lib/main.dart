import 'package:flutter/material.dart';
import 'screens/add_tip_screen.dart';
import 'screens/tips_list_screen.dart';

void main() {
  runApp(const EcoWiseApp());
}

class EcoWiseApp extends StatelessWidget {
  const EcoWiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoWise',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoWise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTipScreen()),
                );
              },
              child: const Text('Cadastrar Dica'),
            ),
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TipsListScreen()),
                );
              },
              child: const Text('Listar Dicas'),
            ),
          ],
        ),
      ),
    );
  }
}
