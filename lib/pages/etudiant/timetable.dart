import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Timetable extends StatefulWidget {
  final String token;
  const Timetable({super.key, required this.token});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? timetableData;
  bool isLoading = true;
  String? selectedDay; // Stocke le jour sélectionné

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    await emploietemps();
  }

  Future<Map<String, dynamic>?> recupererDonneesUtilisateur() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/logged_user/infos'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
        isLoading = false;
      });
      return jsonDecode(response.body);
    } else {
      print('Erreur de récupération des données utilisateur: ${response.statusCode}');
      return null;
    }
  }

  Future<void> emploietemps() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/timetable/${userData?["data"]["user"]["classe"]["id"]}/${userData?["data"]["currentYear"]["id"]}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        timetableData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print('Erreur de récupération des données emploi du temps: ${response.statusCode}');
    }
  }

String _dayToString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "Monday";
    case DateTime.tuesday:
      return "Tuesday";
    case DateTime.wednesday:
      return "Wednesday";
    case DateTime.thursday:
      return "Thursday";
    case DateTime.friday:
      return "Friday";
    case DateTime.saturday:
      return "Saturday";
    case DateTime.sunday:
      return "Sunday";
    default:
      return "Unknown";
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202149),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Timetable',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Text(
                    '( ${timetableData?["data"]["date_debut"]} at ${timetableData?["data"]["date_fin"]} )',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 24,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      color: Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    height: 650,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (String day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'])
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDay = day;
                                  });
                                },
                                child: Card(
                                  color: const Color.fromARGB(255, 224, 238, 253),
                                  elevation: 4,
                                  shadowColor: const Color.fromARGB(255, 216, 216, 216),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Text(
                                          day,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
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
                      selectedDay != null
    ? Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: timetableData?["data"]["seances"]
                  ?.where((seance) {
                    // Extraire le jour de la date
                    final date = DateTime.parse(seance["date"]);
                    final dayOfWeek = _dayToString(date.weekday);
                    return dayOfWeek.toLowerCase() == selectedDay!.toLowerCase();
                  })
                  .length ??
              0,
          itemBuilder: (context, index) {
            // Filtrer les séances pour le jour sélectionné
            final filteredSeances = timetableData?["data"]["seances"]
                ?.where((seance) {
                  final date = DateTime.parse(seance["date"]);
                  final dayOfWeek = _dayToString(date.weekday);
                  return dayOfWeek.toLowerCase() == selectedDay!.toLowerCase();
                })
                .toList();
            final seance = filteredSeances?[index];
            return Card(
              child: ListTile(
                title: Text(seance?["module"]["label"] ?? "Unknown Module", style: TextStyle(
                  fontWeight: FontWeight.w600 , 
                  color: Color.fromARGB(255, 0, 0, 0)
                ), ),
                subtitle: Text(
                    'Type: ${seance?["type_seance"]["label"] ?? ""} | ${seance?["heure_debut"] ?? ""} - ${seance?["heure_fin"] ?? ""} | Salle: ${seance?["salle"]["label"] ?? ""}', style: TextStyle(
                      color: const Color.fromARGB(255, 2, 49, 88)
                    ),),
              ),
            );
          },
        ),
      )
    : const Text(
        'Select a day to view sessions.',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
