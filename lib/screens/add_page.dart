import 'dart:convert';
import 'package:flutter_student_apps/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_apps/service/student_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

String apiUrl = "";

class AddStudentPage extends StatefulWidget {
    final Map? student;
  const AddStudentPage({this.student, super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bolumController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  
  bool isEdit = false;

  @override
  void initState() {
    
    super.initState();
    final student = widget.student;
    if(student != null){
      isEdit = true;
      final isim = student['isim'];
      final bolum = student['bolum'];
      final numara = student['numara'];
      nameController.text = isim;
      bolumController.text = bolum;
      numberController.text = numara;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Öğrenci Güncelle' : 'Öğrenci Ekle'
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'İsim',
              hintText: 'İsim Soyisim Giriniz'),
          ),
          TextField(
            controller: bolumController,
            decoration: InputDecoration(
              labelText: 'Bölüm',
              hintText: 'Bölüm Giriniz'),
          ),
          TextField(
            controller: numberController,
            decoration: InputDecoration(
              labelText: 'Numara',
              hintText: 'Numara Giriniz'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: isEdit? editData : ekleData, 
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isEdit? 'Güncelle':'Ekle'
                ),
            ))
        ],
      ),
    );
  }
  
  Future<void> editData() async{
    final student = widget.student;
    final number = student!['numara'];
    final isim = nameController.text;
    final bolum = bolumController.text;
    final numara = numberController.text;
    final body = {
      'isim' : isim,
      'bolum' : bolum,
      'numara' : numara,
    };
    
    final isSucces = await StudentService.updateStudent(number, body);
    if(isSucces){

      showSuccesMessage(context,message: 'Güncelleme Başarılı');
    }else{
      showErrorMessage(context,message: 'Güncelleme Başarısız');
    }
  }


  Future<void> ekleData()async{
    final isim = nameController.text;
    final bolum = bolumController.text;
    final numara = numberController.text;
    final body = {
      'isim' : isim,
      'bolum' : bolum,
      'numara' : numara,
    };
    final url = apiUrl;
    var client = http.Client();
    final uri = Uri.parse(url);
    final http.Response response = await client.post(uri, 
    body: jsonEncode(body),
    headers:<String,String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // encoding: Encoding.getByName("utf-8")
    );
    if(response.statusCode == 200){
      nameController.text='';
      bolumController.text = '';
      numberController.text = '';
      showSuccesMessage(context,message: 'Ekleme Başarılı');
    }else{
      showErrorMessage(context, message: 'Ekleme Başarısız');
    }
  }


}