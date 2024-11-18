import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tip_model.dart';

class ApiService {
  static const String _baseUrl = 'https://gdapp.com.br/api/sustainable-tips';

  static Future<bool> submitTip(Tip tip) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tip.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Tip>> fetchTips() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Tip.fromJson(json)).toList();
      } else {
        throw Exception('Dicas enviadas com sucesso!!');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }


}
