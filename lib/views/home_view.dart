import 'package:flutter/material.dart';
import 'cadastro_view.dart';
import 'batalha_view.dart';
import 'relatorio_view.dart';
import 'editar_serie_view.dart'; // Importa a nova tela de edição
import '../controllers/serie_controller.dart';
import '../models/serie.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SerieController _serieController = SerieController();
  List<Serie> _series = [];

  @override
  void initState() {
    super.initState();
    _carregarSeries();
  }

  Future<void> _carregarSeries() async {
    final series = await _serieController.getSeries();
    setState(() {
      _series = series;
    });
  }

  void _classificarPorPontuacao() {
    setState(() {
      _series.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));
    });
  }

  void _classificarPorVitorias() {
    setState(() {
      _series.sort((a, b) => b.vitorias.compareTo(a.vitorias));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batalha de Séries'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Pontuação') {
                _classificarPorPontuacao();
              } else if (value == 'Vitórias') {
                _classificarPorVitorias();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Pontuação',
                child: Text('Classificar por Pontuação'),
              ),
              PopupMenuItem(
                value: 'Vitórias',
                child: Text('Classificar por Vitórias'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.sports_kabaddi),
              title: Text('Batalha de Séries'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BatalhaView()),
                );
                _carregarSeries();
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Gerar Relatório'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RelatorioView()));
              },
            ),
          ],
        ),
      ),
      body: _series.isEmpty
          ? Center(child: Text('Nenhuma série cadastrada!'))
          : ListView.builder(
        itemCount: _series.length,
        itemBuilder: (context, index) {
          final serie = _series[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: ListTile(
                onTap: () async {
                  // Navega para a tela de edição da série e recarrega a lista após o retorno
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditarSerieView(serie: serie)),
                  );
                  _carregarSeries();
                },
                contentPadding: EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    serie.capa,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image, size: 60, color: Colors.grey);
                    },
                  ),
                ),
                title: Text(
                  serie.nome,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gênero: ${serie.genero}',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      serie.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${serie.vitorias} Vitórias',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      'Pontuação: ${serie.pontuacao}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => CadastroView()));
          _carregarSeries();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
