import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'recover_password_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Função de login
  Future<bool> _loginUsuario(String email, String senha) async {
    // URL da API corrigida
    final String url = 'https://pizzaria-api.free.beeceptor.com/login';

    final Map<String, String> loginData = {
      'email': email,
      'senha': senha,
    };

    try {
      // Requisição POST
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(loginData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Processa a resposta
        final data = json.decode(response.body);

        // Verifica o status da resposta
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(data['message'] ?? 'Login realizado com sucesso')),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Erro no login')),
          );
          return false;
        }
      } else {
        // Resposta do servidor com código de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro no servidor. Código: ${response.statusCode}')),
        );
        return false;
      }
    } catch (e) {
      // Erro de conexão
      print('Erro no login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor.')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/background.png'), // Adicione sua imagem aqui
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Conecte-se',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Campo de EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'EMAIL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Campo de SENHA
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SENHA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // Botão de Login
                ElevatedButton(
                  onPressed: () async {
                    bool loginSucesso = await _loginUsuario(
                      _emailController.text,
                      _senhaController.text,
                    );

                    if (loginSucesso) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(), // Sem o parâmetro 'items'
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                SizedBox(height: 30),

                // Esqueceu sua senha
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecoverPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Botão de Cadastro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    'Cadastre-se!',
                    style: TextStyle(color: Colors.white),
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
