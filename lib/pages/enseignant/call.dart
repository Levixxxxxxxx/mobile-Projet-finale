import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifrantrackln/pages/enseignant/mainscreen.dart';


class CallForClasse extends StatefulWidget {
  final String token;
  final int seanceId;
 
  const CallForClasse({super.key, required this.token , required this.seanceId });

  @override
  State<CallForClasse> createState() => _CallForClasseState();
}


class _CallForClasseState extends State<CallForClasse> {
   bool isLoading = true;
Map<String, dynamic>? studentData;
   Map<int, int> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await eleveSeance();
  }


 Future<void> eleveSeance( ) async {
    print(" ${widget.seanceId}");
    final  response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/attendance-record/show/${widget.seanceId}'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ); 
   print(' absence ${response.statusCode}');
      if (response.statusCode == 200) {
       setState(() {
        studentData = jsonDecode(response.body);  
        isLoading = false;       
      });
      return jsonDecode(response.body);
    } else {
       print(" annees ${studentData?["data"]}");
      print('Erreur de récupération des données emploie du temps: ${response.statusCode}');        
      return null;
    }
 }


 Future<void> CallSession( ) async {
    
    var url = Uri.parse('http://10.0.2.2:8000/api/trackin/attendance-record/create/${widget.seanceId}');


 List<Map<String, dynamic>> attendances = studentData?["data"].map<Map<String, dynamic>>((student) {
    int studentId = student['id'];
    return {
      "id": studentId, 
      "isDropped": student['isDropped'], 
      "status": _selectedValues[studentId] ?? 1 
    };
  }).toList();

    var body = jsonEncode({
       "attendances": attendances
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: body,

      );
       print(' call ${response.statusCode}');
      print('${attendances}');
      print('${widget.seanceId}');
      if (response.statusCode == 200) {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session success')),    
      ); 
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainscreenEnseignant(token: widget.token)));
    } else {
    print('Erreur de session : ${response.statusCode}');
    print('${response.reasonPhrase}');
        // Afficher un message d'erreur à l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de session.')),
        );
    } 
    } catch (e) {
        print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue.')),
      );
    }
 }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Column(
          children: [
            Text('Call Session' , style: TextStyle(
              fontWeight: FontWeight.w800 ,
              fontSize: 20
            ),),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
                 CallSession();
            },
             child: Text('End Session')),
             Container(
               child : studentData?["data"] != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: studentData?["data"].length,
                      itemBuilder: (context, index) {
                        final student = studentData?["data"][index];
                        final studentId = student['id'];

                        // Valeur sélectionnée pour l'étudiant actuel
                        int selectedValue = _selectedValues[studentId] ?? 1;
            return Card(
              child: Column(
                children: [Row(
                  children: [
                  Icon(Icons.abc),
                  SizedBox(width: 10,),
                  Text('${student['name']} ${student['lastname']}') ,
                                  
                  ],
                
                ),
                
                Row(
                  children: [
    Text('present'),
                Radio(
                value: 1,
                groupValue: selectedValue,
                onChanged:(int? value) {
                                  setState(() {
                                    _selectedValues[studentId] = value!;
                                  });
                                },
                            ),
                   Text('missing'),
                Radio(
                value: -1,
                groupValue: selectedValue,
                onChanged: (int? value) {
                                  setState(() {
                                    _selectedValues[studentId] = value!;
                                  });
                                },
                            ),
                 Text('Delay'),
                Radio(
                value: 0,
                groupValue: selectedValue,
                onChanged: (int? value) {
                                  setState(() {
                                    _selectedValues[studentId] = value!;
                                  });
                                },
                            ),
                  ]
                )
                ]
                
              ),
             
            );          
          },
         )
          : Text('Aucun appel '),
             )
          ],
        ),
      ),
    );
  }
}