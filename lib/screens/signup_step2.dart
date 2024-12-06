import 'package:flutter/material.dart';

class SignupStep2 extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController estadoController;
  final TextEditingController cidadeController;
  final TextEditingController ruaController;
  final TextEditingController bairroController;
  final TextEditingController numeroController;
  final TextEditingController complementoController;

  SignupStep2({
    required this.cepController,
    required this.estadoController,
    required this.cidadeController,
    required this.ruaController,
    required this.bairroController,
    required this.numeroController,
    required this.complementoController,
  });

  // Função para criar os campos de entrada de forma reutilizável
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String hintText = '',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rótulo (Label) fora do campo de texto
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Cor do label
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black), // Cor do texto digitado
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.8), // Cor de fundo do campo
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black54), // Cor do hint
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Borda padrão
                borderRadius: BorderRadius.circular(20), // Borda arredondada
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Borda não focada
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white, width: 2.0), // Borda focada
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Adicionando rolagem
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/background.png'), // Adicione sua imagem aqui
              fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Endereço',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white, // Título em branco
                  ),
                ),
                SizedBox(height: 16),

                // Usando o método _buildTextField para gerar os campos
                _buildTextField(
                    controller: cepController,
                    label: 'CEP',
                    hintText: 'Ex: 11111-111'),
                _buildTextField(
                    controller: estadoController,
                    label: 'Estado',
                    hintText: 'Ex: Goiás'),
                _buildTextField(
                    controller: cidadeController,
                    label: 'Cidade',
                    hintText: 'Ex: Rio Verde'),
                _buildTextField(
                    controller: ruaController,
                    label: 'Rua',
                    hintText: 'Ex: Rua do Sol'),

                // Para o bairro e número, usamos uma linha com dois campos
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          controller: bairroController,
                          label: 'Bairro',
                          hintText: 'Ex: Margarida'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: numeroController,
                          label: 'Número',
                          hintText: 'Ex: 123'),
                    ),
                  ],
                ),

                _buildTextField(
                    controller: complementoController,
                    label: 'Complemento (Opcional)',
                    hintText: 'Ex: Qd 00 Lote 000'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
