import 'package:flutter/material.dart';
import '../models/tip_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/submit_button.dart';

class AddTipScreen extends StatefulWidget {
  const AddTipScreen({Key? key}) : super(key: key);

  @override
  State<AddTipScreen> createState() => _AddTipScreenState();
}

class _AddTipScreenState extends State<AddTipScreen> {
  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _studentController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitTip() async {
    final tip = Tip(
      category: _categoryController.text,
      title: _titleController.text,
      student: _studentController.text,
      description: _descriptionController.text, id: 8,
    );

    final success = await ApiService.submitTip(tip);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dica enviada com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao enviar a dica!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Dicas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _categoryController,
              label: 'Categoria',
            ),
            CustomTextField(
              controller: _titleController,
              label: 'Título',
            ),
            CustomTextField(
              controller: _studentController,
              label: 'Nome do Estudante',
            ),
            CustomTextField(
              controller: _descriptionController,
              label: 'Descrição',
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            SubmitButton(onPressed: _submitTip),
          ],
        ),
      ),
    );
  }
}
