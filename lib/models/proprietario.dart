class Proprietario {
  String nome;
  String telefone;
  String? email;
  String? docId;

  Proprietario({
    required this.nome,
    required this.telefone,
    this.email,
    this.docId,
  });
}
