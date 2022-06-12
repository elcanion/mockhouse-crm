class Imovel {
  String endereco;
  String? proprietario;
  String? telefone;
  String? email;
  String? valor;
  String? tamanho;
  String? areaUtil;

  //detalhes
  String? quartos;
  String? banheiros;
  String? nMatricula;
  String? observacao;
  String? corretorResponsavel;
  String? situacao;
  String? tipoImovel;

  bool? habitse;
  bool? escritura;
  bool? exclusividade;
  bool? parceiros;

  //agenda
  bool agendaDefinida;
  DateTime agenda;
  String docId;

  //imagem
  bool imagemDefinida;
  String imagemUrl;
  String imagemNome;

  Imovel({
    required this.endereco,
    required this.proprietario,
    this.telefone,
    this.email,
    this.valor,
    this.quartos,
    this.banheiros,
    this.tamanho,
    this.areaUtil,
    this.nMatricula,
    this.observacao,
    this.corretorResponsavel,
    this.situacao,
    this.habitse,
    this.exclusividade,
    this.parceiros,
    this.escritura,
    this.tipoImovel,
    required this.agendaDefinida,
    required this.agenda,
    required this.imagemDefinida,
    required this.imagemUrl,
    required this.imagemNome,
    required this.docId,
  });
}
