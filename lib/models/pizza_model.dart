class Pizza {
  final String nome;
  final double preco;
  final String imagem;

  Pizza({required this.nome, required this.preco, required this.imagem});

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      nome: json['nome'],
      preco: json['preco'],
      imagem: json['imagem'],
    );
  }
}
