import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class User extends StatefulWidget {
  final String token;
  const User({super.key, required this.token});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool isLoading = true;
  Map<String, dynamic>? classeData;
  Map<String, dynamic>? eleveData;
  Map<String, dynamic>? selectedClasse;
  String? selectedStudent;
  int? classeid;
  int? eleveid;
  String? selectedFeature;
  bool _isExpanded1 = false; 
  bool _isExpanded2 = false; 
  bool _isExpanded3 = false; 
  Map<String, dynamic>? presenceData;
  Map<String, dynamic>? presence2Data;
  Map<String, dynamic>? presence3Data;
  Map<String, dynamic>? absenceData;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await classe();
  }

  Future<void> justifyAbsence(
      int absenceId, File receipt, String comment) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/trackin/justify/absence/$absenceId'),
    );
    request.headers['Authorization'] = 'Bearer ${widget.token}';
    request.fields['comment'] = comment;

    // Ajout du fichier en tant que form-data
    request.files.add(await http.MultipartFile.fromPath(
      'receipt',
      receipt.path,
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Absence justifiée avec succès.");
    
      await absence();
    } else {
      print(
          "Erreur lors de la justification de l'absence : ${response.statusCode}");
    }
  }

  Future<void> classe() async {
    final response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/classes'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response3.statusCode == 200) {
      setState(() {
        classeData = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> eleve() async {
    final response3 = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/list/students/classe/${classeid}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print(classeid);
    if (response3.statusCode == 200) {
      setState(() {
        eleveData = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> presence() async {
    final response3 = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${eleveid}/1'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print(' absence ${response3.statusCode}');
    if (response3.statusCode == 200) {
      setState(() {
        presenceData = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(" annees ${presenceData?["data"]}");
      print(
          'Erreur de récupération des données emploie du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> presence2() async {
    final response3 = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${eleveid}/2'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print(' absence2 ${response3.statusCode}');
    if (response3.statusCode == 200) {
      setState(() {
        presence2Data = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(" annees ${presence2Data?["data"]}");
      print(
          'Erreur de récupération des données emploie du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> presence3() async {
    final response3 = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${eleveid}/3'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print(' absence ${response3.statusCode}');
    if (response3.statusCode == 200) {
      setState(() {
        presence3Data = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(" annees ${presence3Data?["data"]}");
      print(
          'Erreur de récupération des données emploie du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> absence() async {
    final response3 = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/list/absences/student/${eleveid}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print(' absence ${response3.statusCode}');
    if (response3.statusCode == 200) {
      setState(() {
        absenceData = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(" annees ${absenceData?["data"]["user"]["classe"]["id"]}");
      print(
          'Erreur de récupération des données emploie du temps: ${response3.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF202149),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(children: [
                // Page principale (Liste des classes)
                if (selectedClasse == null && selectedStudent == null)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'USER',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.3),
                                spreadRadius: 6,
                                blurRadius: 24,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          child: classeData?["data"] != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: classeData?["data"].length,
                                  itemBuilder: (context, index) {
                                    final Nclasse = classeData?["data"][index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedClasse = Nclasse;
                                          classeid = Nclasse["id"];
                                          eleve();
                                        });
                                      },
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(
                                            255, 216, 216, 216),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${Nclasse['label']}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "${Nclasse['filiere']['label']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Text('Aucune classe'),
                        ),
                      ],
                    ),
                  ),
                // Détails de la classe sélectionnée
                if (selectedClasse != null && eleveid == null)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          onPressed: () {
                            setState(() {
                              selectedClasse = null;
                            });
                          },
                        ),
                        Text(
                          'Students',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.3),
                                spreadRadius: 6,
                                blurRadius: 24,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          child: eleveData?["data"] != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: eleveData?["data"].length,
                                  itemBuilder: (context, index) {
                                    final Neleve = eleveData?["data"][index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          eleveid = Neleve["id"];
                                          absence();
                                          presence();
                                          presence2();
                                          presence3();
                                        });
                                      },
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(
                                            255, 216, 216, 216),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${Neleve['name']} ${Neleve['lastname']}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "${Neleve['email']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Text('Aucun eleve'),
                        ),
                      ],
                    ),
                  ),
                // Détails de l'eleve sélectionnée
                if (eleveid != null)
                  SingleChildScrollView(
                    child: Column(children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: const Color.fromARGB(255, 255, 255, 255)),
                        onPressed: () {
                          setState(() {
                            eleveid = null;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        ' student  Details',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),

                      const SizedBox(height: 20),
                      // Les trois cartes (emploi du temps, présence, absences)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFeature = "presence";
                              });
                            },
                            child: Card(
                              color: selectedFeature == "presence"
                                  ? const Color(0xFF202149)
                                  : Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 30,
                                      color: selectedFeature == "presence"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Presence",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: selectedFeature == "presence"
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFeature = "absence";
                              });
                            },
                            child: Card(
                              color: selectedFeature == "absence"
                                  ? const Color(0xFF202149)
                                  : Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      size: 30,
                                      color: selectedFeature == "absence"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Missing",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: selectedFeature == "absence"
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (selectedFeature == "presence") ...[
                        Column(
                          children: [
                            Center(
                              child: ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _isExpanded1 =
                                        !_isExpanded1;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text('Semester 1'),
                                      );
                                    },
                                    body: ListTile(
                                      title: presenceData?["data"] != null
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  presenceData?["data"].length,
                                              itemBuilder: (context, index) {
                                                final Npresence =
                                                    presenceData?["data"]
                                                        [index];
                                                return ListTile(
                                                  title: Text(
                                                      "Attendance Rate ${Npresence["attendanceRate"]} %"),
                                                  subtitle: Text(
                                                      ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '),
                                                  leading: Text(
                                                      ' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
                                                );
                                              },
                                            )
                                          : Text('Aucune presence'),
                                    ),
                                    isExpanded: _isExpanded1,
                                    canTapOnHeader:
                                        true, 
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _isExpanded2 =
                                        !_isExpanded2; 
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text('Semester 2'),
                                      );
                                    },
                                    body: ListTile(
                                      title: presence2Data?["data"] != null
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  presence2Data?["data"].length,
                                              itemBuilder: (context, index) {
                                                final Npresence =
                                                    presence2Data?["data"]
                                                        [index];
                                                return ListTile(
                                                  title: Text(
                                                      "Attendance Rate ${Npresence["attendanceRate"]} %"),
                                                  subtitle: Text(
                                                      ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '),
                                                  leading: Text(
                                                      ' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
                                                );
                                              },
                                            )
                                          : Text('Aucune presence'),
                                    ),
                                    isExpanded: _isExpanded2,
                                    canTapOnHeader:
                                        true, 
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _isExpanded3 =
                                        !_isExpanded3; 
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text('Semester 3'),
                                      );
                                    },
                                    body: ListTile(
                                      title: presence3Data?["data"] != null
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  presence3Data?["data"].length,
                                              itemBuilder: (context, index) {
                                                final Npresence =
                                                    presence3Data?["data"]
                                                        [index];
                                                return ListTile(
                                                  title: Text(
                                                      "Attendance Rate ${Npresence["attendanceRate"]} %"),
                                                  subtitle: Text(
                                                      ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '),
                                                  leading: Text(
                                                      ' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
                                                );
                                              },
                                            )
                                          : Text('Aucune presence'),
                                    ),
                                    isExpanded: _isExpanded3,
                                    canTapOnHeader:
                                        true, 
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ] else if (selectedFeature == "absence") ...[
                        Column(
                          children: [
                            Center(
                              child: ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _isExpanded1 =
                                        !_isExpanded1; 
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          'Unjustified Absence',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 0, 24, 88)),
                                        ),
                                      );
                                    },
                                    body: ListTile(
                                      title: absenceData?["data"]
                                                  ["notjustified"] !=
                                              null
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: absenceData?["data"]
                                                      ["notjustified"]
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final Nabsence =
                                                    absenceData?["data"]
                                                        ["notjustified"][index];
                                                return ListTile(
                                                  title: Text(
                                                      Nabsence["type_seance"]),
                                                  subtitle: Text(
                                                      '${Nabsence["seance_heure_debut"]} - ${Nabsence["seance_heure_fin"]} '),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      showJustifyDialog(
                                                          Nabsence["id"]);
                                                    },
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              'Aucune absence non justifiee.'),
                                    ),
                                    isExpanded: _isExpanded1,
                                    canTapOnHeader:
                                        true, 
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _isExpanded2 =
                                        !_isExpanded2; 
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          'Justified Absence',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 0, 24, 88)),
                                        ),
                                      );
                                    },
                                    body: ListTile(
                                      title: absenceData?["data"]
                                                  ["justified"] !=
                                              null
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: absenceData?["data"]
                                                      ["justified"]
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final absence =
                                                    absenceData?["data"]
                                                        ["justified"][index];
                                                return ListTile(
                                                  title: Text(
                                                      absence["type_seance"]),
                                                  subtitle: Text(
                                                      '${absence["seance_heure_debut"]} - ${absence["seance_heure_fin"]} '),
                                                );
                                              },
                                            )
                                          : Text('Aucune absence justifiee.'),
                                    ),
                                    isExpanded: _isExpanded2,
                                    canTapOnHeader:
                                        true, 
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ]),
                  ),
              ]));
  }

  void showJustifyDialog(int absenceId) {
    File? selectedFile;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Justifier une absence'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Commentaire',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Choisir un fichier'),
                  onPressed: () async {
                    try {
                      File? file = await pickFile();
                      if (file != null) {
                        setState(() {
                          selectedFile = file;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Aucun fichier sélectionné.")),
                        );
                      }
                    } catch (e) {
                      print("Erreur lors de la sélection du fichier : $e");
                    }
                  },
                ),
                if (selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Fichier sélectionné : ${selectedFile!.path.split('/').last}',
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Envoyer'),
              onPressed: () async {
                if (selectedFile != null && commentController.text.isNotEmpty) {
                  await justifyAbsence(
                      absenceId, selectedFile!, commentController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Veuillez remplir tous les champs.")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'pdf'
      ],
    );
    print("Résultat du sélecteur de fichiers : $result");
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
