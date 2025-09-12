import 'package:GPPremium/service/authapi.dart'; // Verifique se o caminho está correto
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _formController;
  late Animation<Offset> _formOffset;
  late Animation<double> _formOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _logoAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _formController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _formOffset = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _formOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _logoController.forward().then((_) {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco da tela
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.05,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: FadeTransition(
                    opacity: _logoAnimation,
                    child: Image.asset(
                      'assets/images/gp_logo.png',
                      width: screenWidth * 0.5,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SlideTransition(
                  position: _formOffset,
                  child: FadeTransition(
                    opacity: _formOpacity,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white, // Área do login preta
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            TextFormField(
                              controller: usuarioController,
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline,
                                    color: Colors.black),
                                filled: true,
                                fillColor: Colors.white, // fundo branco do input
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              style:
                              TextStyle(fontSize: 20, color: Colors.black), // texto preto
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe o usuário';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: senhaController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Colors.black),
                                filled: true,
                                fillColor: Colors.white, // fundo branco do input
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              obscureText: true,
                              style:
                              TextStyle(fontSize: 20, color: Colors.black), // texto preto
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe a senha';
                                }
                                if (value.length < 4) {
                                  return 'A senha deve ter 4 dígitos ou mais';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black, // botão branco
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Entrar',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    var authApi = AuthApi();
                                    var response = await authApi.auth({
                                      "login": usuarioController.text,
                                      "senha": senhaController.text,
                                    });

                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (response.status == true) {
                                      Navigator.pushReplacementNamed(
                                          context, "/home");
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Mensagem"),
                                          content: Text(
                                              "${response.message}\n\n${response.error}"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _formOpacity,
                  child: Text(
                    'v1.6.0',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
