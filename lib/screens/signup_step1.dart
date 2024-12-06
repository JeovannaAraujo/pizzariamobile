import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupStep1 extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;

  SignupStep1({
    required this.nomeController,
    required this.emailController,
    required this.telefoneController,
  });

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
              // Título "Bora Começar!"
              Text(
                'Bora Começar!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              // Campo Nome
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 16),

              // Campo E-mail
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'E-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),

              // Campo Telefone
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Telefone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text
        .replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos

    // Limita o número de caracteres a 11 (DDD + número de celular)
    if (digitsOnly.length > 11) {
      digitsOnly = digitsOnly.substring(0, 11);
    }

    String formattedText = '';
    if (digitsOnly.length >= 8) {
      // Formato completo: (XX) XXXXX-XXXX
      formattedText =
          '(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7)}';
    } else if (digitsOnly.length >= 3) {
      // Parcial até 7 dígitos: (XX) XXXXX
      formattedText =
          '(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2)}';
    } else if (digitsOnly.length > 0) {
      // Parcial com DDD: (XX
      formattedText = '(${digitsOnly.substring(0)}';
    }

    // Calcula a posição correta do cursor
    int cursorPosition =
        formattedText.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
