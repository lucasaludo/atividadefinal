class Serie {
  String id;
  String nome;
  String genero;
  String descricao;
  String capa; // URL da imagem
  int pontuacao;
  int vitorias;

  Serie({
    required this.id,
    required this.nome,
    required this.genero,
    required this.descricao,
    required this.capa,
    this.pontuacao = 0,
    this.vitorias = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'genero': genero,
    'descricao': descricao,
    'capa': capa,
    'pontuacao': pontuacao,
    'vitorias': vitorias,
  };

  factory Serie.fromMap(Map<String, dynamic> map) => Serie(
    id: map['id'],
    nome: map['nome'],
    genero: map['genero'],
    descricao: map['descricao'],
    capa: map['capa'],
    pontuacao: map['pontuacao'] ?? 0,
    vitorias: map['vitorias'] ?? 0,
  );
}
