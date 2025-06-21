import 'package:GPPremium/service/authapi.dart';
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

  AnimationController _logoController;
  Animation<double> _logoAnimation;

  AnimationController _formController;
  Animation<Offset> _formOffset;
  Animation<double> _formOpacity;

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
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.05),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Faça seu login',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: usuarioController,
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                                counterText: '',
                              ),
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: TextStyle(fontSize: 20),
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
                                prefixIcon: Icon(Icons.lock_outline),
                                counterText: '',
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              style: TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe a senha';
                                }
                                if (value.length != 6) {
                                  return 'A senha deve ter exatamente 6 dígitos';
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
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                    color: Colors.white)
                                    : Text('Entrar',
                                    style: TextStyle(fontSize: 18)),
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
                                                Navigator.of(context)
                                                    .pop();
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
                    'v1.0.67',
                    style: TextStyle(color: Colors.white70),
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
