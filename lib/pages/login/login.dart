import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifrantrackln/pages/coordinateur/Timetable.dart';
import 'package:ifrantrackln/pages/coordinateur/mainscreen.dart';
import 'package:ifrantrackln/pages/enseignant/mainscreen.dart';
import 'package:ifrantrackln/pages/etudiant/mainscreen.dart';
import 'dart:convert';
import 'package:ifrantrackln/pages/parent/mainscreen.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


 Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
   
    var url = Uri.parse('http://10.0.2.2:8000/api/trackin/login');

  
    var body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,

      );

    print('Statut HTTP: ${response.statusCode}');
    print('Réponse du serveur: ${response.body}');
    

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body); 
         var token = jsonResponse["data"]["token"];
   
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('connection reussi.')),    
      ); 
      switch (jsonResponse["data"]["user"]["role"]["id"]) {
        case 1:
             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainscreenEtudiant(token: token)));   
          break;
           case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainscreenParent(token: token))); 
          break;
           case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainscreenEnseignant(token: token))); 
          break;
           case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainscreenCoordinator(token: token))); 
          break;
        default:
      }
         
      } else {
        print('Erreur de connexion : ${response.statusCode}');
     
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion.')),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body:
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 280,
                   
                    child: Image(image: AssetImage('assets/TRACKLN.png')),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                           Form(
                             key: _formKey,
                            child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
    Container(
                    height: 70,
                    width: 280,
                    child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress, 
                      decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color:  Color(0xFFE5ECF2), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                       ), 
                        filled: true,
                        fillColor: Color(0xFFF9FAFC),
                       labelStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCCCCCC)
                       ),
                        labelText: ' Email ',
                        border: OutlineInputBorder(),
                      ),
                        validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
                    )                 
                  ),

    SizedBox(
                    height: 10,
                  ),

                  Container(
                    height: 70,
                    width: 280,
                   
                    child: TextFormField(
                      controller: _passwordController,
                        obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color:  Color(0xFFE5ECF2), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                       ), 
                          filled: true,
                        fillColor: Color(0xFFF9FAFC),
                           labelStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCCCCCC)
                       ),
                        labelText: 'Password ',
                        border: OutlineInputBorder(

                        ),
                      ),
                       validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
                    ),                 
                  ),
      SizedBox(
                    height: 10,
                  ),
   Container(
                    height: 70,
                    width: 280,
                    child: ElevatedButton(
                       onPressed: _loginUser,
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF202149)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                    ),
                    child: Text('LOGIN', style: TextStyle(
                      color: Colors.white
                    ),),
                    ),
                  )
                ],
              ),
            ),
                               ]
                            )
                           
                           )



              
                
               
               
          )
    );
  }
}