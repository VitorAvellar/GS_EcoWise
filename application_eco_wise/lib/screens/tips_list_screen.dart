import 'package:flutter/material.dart';
import '../models/tip_model.dart';
import '../services/api_service.dart';

class TipsListScreen extends StatefulWidget {
  const TipsListScreen({Key? key}) : super(key: key);

  @override
  State<TipsListScreen> createState() => _TipsListScreenState();
}

class _TipsListScreenState extends State<TipsListScreen> {
  late Future<List<Tip>> _tipsFuture;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  void _loadTips() {
    setState(() {
      _tipsFuture = ApiService.fetchTips();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Dicas'),
      ),
      body: FutureBuilder<List<Tip>>(
        future: _tipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dicas: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma dica cadastrada.'),
            );
          } else {
            final tips = snapshot.data!;
            return ListView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(tip.title),
                    subtitle: Text('${tip.category} - ${tip.student}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                    
                    ),
                    onTap: () {
                      _showTipDetails(context, tip);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showTipDetails(BuildContext context, Tip tip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tip.title),
          content: Text(tip.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
