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

  void _updateStudentName(String id) async {
    final controller = TextEditingController();
    final success = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar Nome do Aluno'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Novo Nome',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  final result = await ApiService.updateStudentName(id, newName);
                  Navigator.pop(context, result);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nome não pode ser vazio!')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome atualizado com sucesso!')),
      );
      _loadTips();
    } else if (success == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o nome.')),
      );
    }
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
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _updateStudentName(tip.id.toString()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, tip.id as String),
                        ),
                      ],
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

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Dica'),
          content: const Text('Tem certeza que deseja excluir esta dica?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTip(id);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTip(String id) async {
    final success = await ApiService.deleteTip(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dica excluída com sucesso!')),
      );
      _loadTips();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir a dica.')),
      );
    }
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
