import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Presence extends StatefulWidget {
  final String token;
  const Presence({super.key, required this.token});

  @override
  State<Presence> createState() => _PresenceState();
}

class _PresenceState extends State<Presence> {
  bool _isExpanded1 = false; 
  bool _isExpanded2 = false; 
  bool _isExpanded3 = false; 
  bool isLoading = true;
Map<String, dynamic>? userData;
Map<String, dynamic>? presenceData;
 Map<String, dynamic>?  presence2Data ;
  Map<String, dynamic>?  presence3Data ;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    presence();
    presence2();
    presence3();
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



 Future<void> presence( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${userData?["data"]["user"]["id"]}/1'),
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
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }



 Future<void> presence2( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${userData?["data"]["user"]["id"]}/2'),
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
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }




 Future<void> presence3( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${userData?["data"]["user"]["id"]}/3'),
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
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded1 = !_isExpanded1; 
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Semester 1'),
                );
              },
              body: ListTile(
                title:   presenceData?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presenceData?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presenceData?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
              ),
              isExpanded: _isExpanded1,
              canTapOnHeader: true, 
            ),
          ],
            ),
        ),
         Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded2 = !_isExpanded2; 
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Semester 2'),
                );
              },
              body: ListTile(
                title:   presence2Data?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presence2Data?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presence2Data?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
              ),
              isExpanded: _isExpanded2,
              canTapOnHeader: true, 
            ),
          ],
          
            ),
        ),
          Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded3 = !_isExpanded3; 
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Semester 3'),
                );
              },
              body:ListTile(
                title:   presence3Data?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presence3Data?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presence3Data?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
              ),
              isExpanded: _isExpanded3,
              canTapOnHeader: true, 
            ),
          ],
          
            ),
        )
          ],
          
        )
      ),
    );
  }
}