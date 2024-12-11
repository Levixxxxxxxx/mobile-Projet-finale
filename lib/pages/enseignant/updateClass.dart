import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifrantrackln/pages/enseignant/mainscreen.dart';

class UpadateForClass extends StatefulWidget {
   final String token;
  final int seanceId;

  const UpadateForClass({super.key, required this.token, required  this.seanceId});

  @override
  State<UpadateForClass> createState() => _UpadateForClassState();
}

class _UpadateForClassState extends State<UpadateForClass> {
 bool isLoading = true;
Map<String, dynamic>? studentData;
   Map<int, int> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await eleveSeanceEdit();
  }


Future<void> eleveSeanceEdit() async {
  print(" ${widget.seanceId}");
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/trackin/attendance-record/edit/${widget.seanceId}'),
    headers: {
      'Authorization': 'Bearer ${widget.token}',
    },
  );

  print(' absence ${response.statusCode}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Initialisation des valeurs par défaut pour _selectedValues
    final Map<int, int> initialValues = {};
    for (var student in data["data"]) {
      initialValues[student['id']] = student['attendanceStatus'];
    }

    setState(() {
      studentData = data;
      _selectedValues = initialValues; // Met à jour les valeurs par défaut
      isLoading = false;
    });

    return data;
  } else {
    print('Erreur de récupération des données: ${response.statusCode}');
    return null;
  }
}

 Future<void> UpdateSession( ) async {
    
    var url = Uri.parse('http://10.0.2.2:8000/api/trackin/attendance-record/update/${widget.seanceId}');


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
       print(' update ${response.statusCode}');
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
    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Column(
          children: [
            Text('Update Session' , style: TextStyle(
              fontWeight: FontWeight.w800 ,
              fontSize: 20
            ),),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
                 UpdateSession();
            },
             child: Text('Edit Session')),
             Container(
               child : studentData?["data"] != null
                  ? ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: studentData?["data"].length,
  itemBuilder: (context, index) {
    final student = studentData?["data"][index];
    final studentId = student['id'];

    // Utiliser la valeur initialisée dans _selectedValues
    int selectedValue = _selectedValues[studentId] ?? 1;

    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.abc),
              SizedBox(width: 10),
              Text('${student['name']} ${student['lastname']}'),
            ],
          ),
          Row(
            children: [
              Text('Present'),
              Radio(
                value: 1,
                groupValue: selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    _selectedValues[studentId] = value!;
                  });
                },
              ),
              Text('Missing'),
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
            ],
          ),
        ],
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