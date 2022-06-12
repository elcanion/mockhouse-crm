class Lead {
  String codCliente;
  String nome;
  String telefone;
  String? email;
  String situacao;
  String emailCorretor;
  String? detalhes;
  String? docId;

  Lead({
    required this.codCliente,
    required this.nome,
    required this.telefone,
    this.email,
    required this.situacao,
    required this.emailCorretor,
    this.detalhes,
    this.docId,
  });
}
