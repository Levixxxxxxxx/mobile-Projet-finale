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
  String? selectedValue; // Classe sélectionnée
  String? selectedClassId; // L'ID de la classe sélectionnée
  String?
      selectedDataType; // Type de données (Taux de présence ou volume de cours)
  String? selectedSemester; // Semestre sélectionné (1, 2, ou 3)
  List<String> classes = []; // Liste des classes récupérées
  List<String> dataTypes = [
    'Taux de présence',
    'Volume de cours'
  ]; // Types de données
  List<String> semesters = ['1', '2', '3']; // Semestres disponibles
  List<dynamic> allclasseData = []; // Données de présence de toutes les classes
  List<dynamic> studentAttendanceData = []; // Données de présence des étudiants
  List<dynamic> courseHoursData = []; // Données des heures de cours
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

// Récupérer les heures de cours dispensées pour les semestres
  Future<void> fetchCourseHours(String yearSegment) async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/gethours/classes/year_segments/$yearSegment'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      setState(() {
        // Extraire les segments d'année
        courseHoursData = decodedData['data']
            .map((classe) => {
                  "classe_id": classe["classe_id"],
                  "segments": classe["yearSegments"]
                })
            .toList();
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des heures de cours: ${response.statusCode}');
    }
  }

  // Récupérer les taux de présence des étudiants pour une classe spécifique
  Future<void> fetchStudentAttendance(String classId) async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/presence/students/classe/$classId'),
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
      print(
          'Erreur de récupération des données des étudiants: ${response.statusCode}');
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
                  // Sélection de la classe
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
                            // Récupérer les données pour toutes les classes
                            await fetchAllClassesPresence();
                          } else {
                            // Trouver l'ID de la classe sélectionnée
                            final selectedClass = allclasseData.firstWhere(
                              (item) => item['label'] == newValue,
                              orElse: () => null,
                            );
                            if (selectedClass != null) {
                              setState(() {
                                allclasseData
                                    .clear(); // Réinitialise les données de toutes les classes
                                studentAttendanceData
                                    .clear(); // Réinitialise les données des étudiants
                              });

                              selectedClassId = selectedClass['id'].toString();
                              await fetchStudentAttendance(selectedClassId!);
                            } else {
                              print('Classe sélectionnée introuvable.');
                            }
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

                  // Sélection du type de données
                  if (selectedValue == 'All classes')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          hint: Text('Choisissez un type de données'),
                          value: selectedDataType,
                          onChanged: (String? newValue) async {
                            setState(() {
                              selectedDataType = newValue;
                            });

                            if (newValue == 'Taux de présence') {
                              await fetchAllClassesPresence();
                            } else if (newValue == 'Volume de cours') {
                              // Si l'utilisateur choisit "Volume de cours", afficher aussi le semestre
                            }
                          },
                          items: dataTypes.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  // Sélection du semestre
                  if (selectedDataType == 'Volume de cours' &&
                      selectedValue == 'All classes')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          hint: Text('Choisissez un semestre'),
                          value: selectedSemester,
                          onChanged: (String? newValue) async {
                            setState(() {
                              selectedSemester = newValue;
                            });

                            if (newValue != null) {
                              await fetchCourseHours(
                                  newValue); // Récupérer les heures pour le semestre sélectionné
                            }
                          },
                          items: semesters.map((String semester) {
                            return DropdownMenuItem<String>(
                              value: semester,
                              child: Text('Semestre $semester'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  // Affichage des données de présence ou d'heures de cours
                  if (selectedDataType == 'Taux de présence' &&
                      allclasseData.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Taux de présence pour toutes les classes',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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

                  // Affichage des heures de cours
                  if (selectedDataType == 'Volume de cours' &&
                      courseHoursData.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Volume de cours dispensé pour le semestre $selectedSemester',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: courseHoursData.length,
                          itemBuilder: (context, index) {
                            final classItem = courseHoursData[index];
                            final segments = classItem['segments']
                                .where((segment) =>
                                    segment['number'].toString() ==
                                    selectedSemester)
                                .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: segments.map<Widget>((segment) {
                                return ListTile(
                                  title: Text(
                                      'Classe ID: ${classItem['classe_id']}'),
                                  subtitle: Text(
                                    'Semestre ${segment['number']} : Heures de cours : ${segment['workedHours'] ?? 'Aucune donnée'}',
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),

                  // Affichage des taux de présence des étudiants pour une classe spécifique
                  if (selectedValue != 'All classes' &&
                      studentAttendanceData.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Taux de présence des étudiants',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: studentAttendanceData.length,
                          itemBuilder: (context, index) {
                            final student = studentAttendanceData[index];
                            return ListTile(
                              title: Text(
                                  '${student['name']} ${student['lastname']}'),
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
