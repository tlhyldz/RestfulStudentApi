

import 'package:flutter/material.dart';
import 'package:flutter_student_apps/screens/add_page.dart';
import 'package:flutter_student_apps/service/student_service.dart';
import 'package:flutter_student_apps/utils/snackbar_helper.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List students = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Öğrenciler',),
        centerTitle: true,

      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchStudent,
          child: Visibility(
            visible: students.isNotEmpty,
            replacement: Center(
              child: Text('Öğrenci Bulunmamaktadır.',
              style: Theme.of(context).textTheme.headline3,),
            ),
            child: ListView.builder(
              itemCount: students.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context,index){
                final ogrenci = students[index] as Map;
                
                final numara = ogrenci['numara'].toString();
                return Card(
                  child: ListTile(
                  title: Text(ogrenci['isim'].toString()),
                  subtitle: Text(ogrenci['numara'].toString()),
                  leading: CircleAvatar(child :Text(ogrenci['id'].toString())),
                  trailing: 
                  PopupMenuButton(onSelected: (value){
                    if(value=='Güncelle'){
                      navigateToEditPage(ogrenci);
                    }else if(value == 'Sil'){
                      deleteByNumber(numara);
                      
                    }
                  },
                  itemBuilder: (context){
                    return[
                      PopupMenuItem(child: Text('Güncelle'), value: 'Güncelle'),
                      PopupMenuItem(child: Text('Sil'), value: 'Sil',),
                    ];
                  },
                  )
                            //      Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     IconButton(onPressed:() => navigateToEditPage(ogrenci), 
                            //     icon: const Icon(Icons.edit)),
                          
                            //     IconButton(
                            //       onPressed: (() =>
                            //         deleteByNumber(numara)),
                                
                            //     icon: const Icon(Icons.person_remove_alt_1_outlined))
                            //   ],
                            // ),
                              ),
                );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, 
        label: Text('Öğrenci Ekle')),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder:(context)=> AddStudentPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchStudent();
  }
  Future<void> navigateToEditPage(Map ogrenci) async {
    
    final route = MaterialPageRoute(builder:(context)=> AddStudentPage(student: ogrenci));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchStudent();
    
  }

  Future<void> fetchStudent() async{

    final response = await StudentService.fetchStudents();
    if(response != null){
      setState(() {
        students = response;
      });
    }else{
      showErrorMessage(context, message: 'Bir şeyler ters gitti :/');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteByNumber (String numara)async{

    final isSuccess = await StudentService.deleteByNumber(numara);
    if(isSuccess){
      final filtered = students.where((element) => element['numara'] != numara).toList();
      setState(() {
        students = filtered;
      });
    }else{
      showErrorMessage(context, message:'Öğrenci Silinemedi');
    }
  }

}