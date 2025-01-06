import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Graphic extends StatefulWidget {
  final String token;
  const Graphic({super.key, required this.token});

  @override
  State<Graphic> createState() => _GraphicState();
}

class _GraphicState extends State<Graphic> {
  String? selectedValue; // La classe sélectionnée
  String? selectedClassId; // L'ID de la classe sélectionnée
  List<String> classes = []; // Liste des classes récupérées
  List<dynamic> allclasseData = []; // Données de présence de toutes les classes
  List<dynamic> studentAttendanceData = []; // Données de présence des étudiants
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchClasses();
  }

  // Récupérer la liste des classes
  Future<void> fetchClasses() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/classes'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      final List<dynamic> data = decodedData['data'];
      setState(() {
        classes = ['All classes'] +
            data.map<String>((item) => item['label'] as String).toList();
        isLoading = false;
      });
    } else {
      print('Erreur de récupération des classes: ${response.statusCode}');
    }
  }

  // Récupérer les taux de présence de toutes les classes
  Future<void> fetchAllClassesPresence() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/classes'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      setState(() {
        allclasseData = decodedData['data'];
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des données de présence: ${response.statusCode}');
    }
  }

  // Récupérer les taux de présence des étudiants pour une classe spécifique
  Future<void> fetchStudentAttendance(String classId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/students/classe/$classId'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      setState(() {
        studentAttendanceData = decodedData['data']['studentAttendanceRate'];
        isLoading = false;
      });
    } else {
      print('Erreur de récupération des données des étudiants: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<String>(
                        hint: Text('Sélectionnez une classe'),
                        value: selectedValue,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedValue = newValue;
                          });

                          if (newValue == 'All classes') {
                            await fetchAllClassesPresence();
                          } else {
                            // Récupérer l'ID de la classe sélectionnée
                            final selectedClass = allclasseData.firstWhere(
                                (item) => item['label'] == newValue);
                            selectedClassId = selectedClass['id'].toString();
                            await fetchStudentAttendance(selectedClassId!);
                          }
                        },
                        items: classes.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  if (selectedValue != null && selectedValue != 'All classes')
                    ...[
                      SizedBox(height: 20),
                      Text(
                        'Classe sélectionnée : $selectedValue',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  if (selectedValue == 'All classes' && allclasseData.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Taux de présence pour toutes les classes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allclasseData.length,
                          itemBuilder: (context, index) {
                            final classItem = allclasseData[index];
                            return ListTile(
                              title: Text(classItem['label']),
                              subtitle: Text(
                                  'Taux de présence : ${classItem['classeAttendanceRate']}%'),
                            );
                          },
                        ),
                      ],
                    ),
                  if (selectedValue != 'All classes' && studentAttendanceData.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Taux de présence des étudiants',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: studentAttendanceData.length,
                          itemBuilder: (context, index) {
                            final student = studentAttendanceData[index];
                            return ListTile(
                             
                              title: Text('${student['name']} ${student['lastname']}'),
                              subtitle: Text(
                                  'Taux de présence : ${student['attendanceRate']}%'),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
