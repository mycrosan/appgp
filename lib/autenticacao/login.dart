import 'dart:convert';
import 'package:GPPremium/screens/dashboard/home.dart';
import 'package:GPPremium/service/authapi.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  TextEditingController usuarioController = new TextEditingController();
  TextEditingController senhaController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();
  Map<String, String> headers = {"Content-Type": "application/json"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/gp_logo.png',
                    width: 500,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400,
                    height: 430,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _construirFormulario(context),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'v1.0.24',
                        style: TextStyle(color: Colors.white),
                      ),
                    ])
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor);
  }

  Widget _construirFormulario(context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Text(
              'Faça seu login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Usuário'),
              maxLength: 10,
              validator: (value) {
                if (value.length == 0) return 'Informar o Usuário!';
              },
              keyboardType: TextInputType.text,
              controller: usuarioController,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Senha'),
              maxLength: 15,
              validator: (value) {
                if (value.length == 0) return 'Informar uma senha!';
              },
              keyboardType: TextInputType.text,
              controller: senhaController,
              autofocus: false,
              obscureText: true,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlineButton(
                textColor: Theme.of(context).accentColor,
                highlightColor: Color.fromRGBO(0, 0, 0, 0.2),
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                child: Text('Entrar'),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    var authApi = new AuthApi();
                    var response = await authApi.auth({
                      "login": this.usuarioController.text,
                      "senha": this.senhaController.text
                    });
                    if (response.status == true) {
                      Navigator.pushReplacementNamed(context, "/home");
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Mensagem"),
                            content: Text(response.message + "\n\n"+ response.error),
                            actions: [
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                          ;
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ));
  }
}
