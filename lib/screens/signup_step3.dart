import 'package:flutter/material.dart';

class SignupStep3 extends StatefulWidget {
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;

  SignupStep3({
    required this.senhaController,
    required this.confirmarSenhaController,
  });

  @override
  _SignupStep3State createState() => _SignupStep3State();
}

class _SignupStep3State extends State<SignupStep3> {
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  String? _erroSenha;

  // Função para validar se as senhas coincidem
  String? _validarSenhas() {
    if (widget.senhaController.text != widget.confirmarSenhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // Função para alternar a visibilidade da senha
  void _toggleSenhaVisivel() {
    setState(() {
      _senhaVisivel = !_senhaVisivel;
    });
  }

  // Função para alternar a visibilidade da confirmação de senha
  void _toggleConfirmarSenhaVisivel() {
    setState(() {
      _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quase lá!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white, // Título em branco
                ),
              ),
              SizedBox(height: 16),
              // Campo de senha
              TextField(
                controller: widget.senhaController,
                style: TextStyle(color: Colors.white), // Texto branco
                decoration: InputDecoration(
                  hintText: 'Digite sua senha',
                  hintStyle:
                      TextStyle(color: Colors.white70), // Placeholder branco
                  errorText: _erroSenha,
                  errorStyle: TextStyle(color: Colors.red), // Erro vermelho
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white, // Ícones brancos
                    ),
                    onPressed: _toggleSenhaVisivel,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white), // Borda habilitada
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, width: 2.0), // Borda focada
                  ),
                ),
                obscureText: !_senhaVisivel,
              ),
              SizedBox(height: 16),
              // Campo de confirmação de senha
              TextField(
                controller: widget.confirmarSenhaController,
                style: TextStyle(color: Colors.white), // Texto branco
                decoration: InputDecoration(
                  hintText: 'Confirme sua senha',
                  hintStyle:
                      TextStyle(color: Colors.white70), // Placeholder branco
                  errorText: _validarSenhas(),
                  errorStyle: TextStyle(color: Colors.red), // Erro vermelho
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmarSenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white, // Ícones brancos
                    ),
                    onPressed: _toggleConfirmarSenhaVisivel,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white), // Borda habilitada
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 9, 1, 77),
                        width: 2.0), // Borda focada
                  ),
                ),
                obscureText: !_confirmarSenhaVisivel,
                onChanged: (value) {
                  setState(() {
                    _erroSenha = _validarSenhas();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
