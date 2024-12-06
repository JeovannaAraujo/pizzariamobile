import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'signup_step1.dart'; // Tela 1 - Informações Pessoais
import 'signup_step2.dart'; // Tela 2 - Endereço
import 'signup_step3.dart'; // Tela 3 - Senha

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0; // Controla o passo atual do processo de cadastro

  // Controladores de cada etapa
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Função para avançar para o próximo passo
  void _proximoPasso() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Chama a função de cadastro na última etapa
      if (_validarFormulario()) {
        _fazerCadastro();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Por favor, preencha todos os campos corretamente.')),
        );
      }
    }
  }

  // Função para cancelar e voltar para a tela anterior
  void _cancelarCadastro() {
    Navigator.pop(context); // Retorna para a tela anterior
  }

  // Função para validar o formulário (verificar senhas, campos obrigatórios)
  bool _validarFormulario() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefoneController.text.isEmpty || // Verifica o telefone
        _cepController.text.isEmpty ||
        _estadoController.text.isEmpty ||
        _cidadeController.text.isEmpty ||
        _ruaController.text.isEmpty ||
        _bairroController.text.isEmpty ||
        _numeroController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      return false;
    }

    // Verificar se as senhas coincidem
    if (_senhaController.text != _confirmarSenhaController.text) {
      return false;
    }

    return true;
  }

  // Função para fazer o cadastro na API do Beeceptor
  Future<void> _fazerCadastro() async {
    // Aqui você faz a chamada para a API Beeceptor
    final url = Uri.parse('https://pizzaria-api.free.beeceptor.com/signup');

    final dados = {
      'nome': _nomeController.text,
      'email': _emailController.text,
      'telefone': _telefoneController.text,
      'cep': _cepController.text,
      'estado': _estadoController.text,
      'cidade': _cidadeController.text,
      'rua': _ruaController.text,
      'bairro': _bairroController.text,
      'numero': _numeroController.text,
      'complemento': _complementoController.text,
      'senha': _senhaController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dados),
      );

      if (response.statusCode == 200) {
        print('Cadastro feito com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        // Aqui você pode redirecionar para outra tela, como a tela de login
        Navigator.pop(
            context); // Volta para a tela anterior ou vai para a tela de login
      } else {
        print('Erro ao cadastrar');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar, tente novamente.')),
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão, tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Estende o corpo atrás do AppBar
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Define a cor da seta de voltar
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              }
            });
          },
        ),
        title: Text(
          'Cadastre-se ${_currentStep + 1}/3',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(239, 9, 2, 52),
        elevation: 0,
      ),

      body: Stack(
        children: [
          // Gradiente de fundo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x00117004), Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: _getStepWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(239, 9, 2, 52),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão Cancelar
              ElevatedButton(
                onPressed: _cancelarCadastro,
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              // Botão Continuar ou Concluir
              ElevatedButton(
                onPressed: _proximoPasso,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: Text(_currentStep == 2 ? 'Concluir' : 'Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função que retorna o widget correspondente ao passo atual
  Widget _getStepWidget() {
    switch (_currentStep) {
      case 0:
        return SignupStep1(
          nomeController: _nomeController,
          emailController: _emailController,
          telefoneController: _telefoneController,
        );
      case 1:
        return SignupStep2(
          cepController: _cepController,
          estadoController: _estadoController,
          cidadeController: _cidadeController,
          ruaController: _ruaController,
          bairroController: _bairroController,
          numeroController: _numeroController,
          complementoController: _complementoController,
        );
      case 2:
        return SignupStep3(
          senhaController: _senhaController,
          confirmarSenhaController: _confirmarSenhaController,
        );
      default:
        return SignupStep1(
          nomeController: _nomeController,
          emailController: _emailController,
          telefoneController: _telefoneController,
        );
    }
  }
}
