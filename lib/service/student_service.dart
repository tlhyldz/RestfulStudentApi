import 'package:http/http.dart' as http;
import 'dart:convert';

String apiUrl = "";

class StudentService{
  static Future<bool> deleteByNumber(String numara) async {
    final url = "$apiUrl/$numara";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchStudents() async {
    final url = apiUrl;
    final uri = Uri.parse(url);
    final response = await http.get(uri);

     if(response.statusCode == 200){
      final json = jsonDecode(utf8.decode(response.bodyBytes))as Map;
      final result = json['ogrenciler'] as List;
      return result;
  }else{
    return null;
  }

  
}

  static Future<bool> updateStudent (String number, Map body) async {
    final url = "$apiUrl/$number";
    final uri = Uri.parse(url);
    final response = await http.put(uri, 
    body: jsonEncode(body),
    headers:<String,String> {
      'Content-Type': 'application/json; charset=UTF-8',
    }
    );
    return response.statusCode == 200;
  }
}