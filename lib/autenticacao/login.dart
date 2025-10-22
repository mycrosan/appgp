import 'package:GPPremium/service/authapi.dart';
import 'package:GPPremium/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  String appVersion = '';

  AnimationController _logoController;
  Animation<double> _logoAnimation;

  AnimationController _formController;
  Animation<Offset> _formOffset;
  Animation<double> _formOpacity;

  AnimationController _backgroundController;
  Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Animação do logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Animação do formulário
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _formOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));

    _formOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    // Animação do background
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Sequência de animações
    _logoController.forward().then((_) {
      _formController.forward();
    });

    // Obter versão do app
    _getAppVersion();
  }

  // Função para obter a versão do aplicativo
  void _getAppVersion() async {
    // Versão obtida da configuração centralizada
    try {
      final version = await AppConfig.formattedVersion;
      setState(() {
        appVersion = version;
      });
    } catch (e) {
      // Fallback em caso de erro
      setState(() {
        appVersion = 'v1.7.1+18';
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _backgroundController.dispose();
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                        const Color(0xFF1E3A8A), // Azul escuro
                        const Color(0xFF3B82F6), // Azul médio
                        _backgroundAnimation.value,
                      ) ??
                      const Color(0xFF1E3A8A),
                  Color.lerp(
                        const Color(0xFF3B82F6), // Azul médio
                        const Color(0xFF60A5FA), // Azul claro
                        _backgroundAnimation.value,
                      ) ??
                      const Color(0xFF3B82F6),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: SizedBox(
                  height: screenHeight - MediaQuery.of(context).padding.bottom,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo com animação melhorada
                      ScaleTransition(
                        scale: _logoAnimation,
                        child: FadeTransition(
                          opacity: _logoAnimation,
                          child: Image.asset(
                            'assets/images/gp_logo.png',
                            width: screenWidth * 0.7,
                            height: screenWidth * 0.3,
                          ),
                        ),
                      ),

                      // Título de boas-vindas
                      FadeTransition(
                        opacity: _formOpacity,
                        child: Column(
                          children: [
                            Text(
                              'Bem-vindo',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Faça login para continuar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Formulário com design glassmorphism
                      SlideTransition(
                        position: _formOffset,
                        child: FadeTransition(
                          opacity: _formOpacity,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Campo de usuário
                                  _buildInputField(
                                    controller: usuarioController,
                                    label: 'Usuário',
                                    icon: Icons.person_outline,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe o usuário';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Campo de senha
                                  _buildInputField(
                                    controller: senhaController,
                                    label: 'Senha',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
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

                                  const SizedBox(height: 32),

                                  // Botão de login
                                  _buildLoginButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Versão do app
                      FadeTransition(
                        opacity: _formOpacity,
                        child: FutureBuilder<String>(
                          future: AppConfig.formattedVersion,
                          builder: (context, snapshot) {
                            String displayVersion = appVersion.isNotEmpty 
                                ? appVersion 
                                : (snapshot.hasData ? snapshot.data : 'v1.7.1+18');
                            
                            return Text(
                              displayVersion,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Método para construir campos de entrada personalizados
  Widget _buildInputField({
    TextEditingController controller,
    String label,
    IconData icon,
    bool isPassword = false,
    String Function(String) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 22,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  // Método para construir o botão de login
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Color(0xFF1E3A8A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        onPressed: isLoading ? null : _handleLogin,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
                ),
              )
            : Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  // Método para lidar com o login
  Future<void> _handleLogin() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        var authApi = AuthApi();
        var response = await authApi.auth({
          "login": usuarioController.text,
          "senha": senhaController.text,
        });

        setState(() {
          isLoading = false;
        });

        if (response.status == true) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          _showErrorDialog(response.message, response.error);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(
            "Erro de conexão", "Verifique sua internet e tente novamente");
      }
    }
  }

  // Método para mostrar diálogo de erro
  void _showErrorDialog(String message, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Erro de Autenticação",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        content: Text("$message\n\n$error"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Color(0xFF1E3A8A),
            ),
            child: Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
