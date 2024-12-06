import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../controllers/serie_controller.dart';
import '../models/serie.dart';

class BatalhaView extends StatefulWidget {
  @override
  _BatalhaViewState createState() => _BatalhaViewState();
}

class _BatalhaViewState extends State<BatalhaView> {
  final SerieController _serieController = SerieController();
  List<Serie> _series = [];
  Serie? _serie1;
  Serie? _serie2;

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

  void _selecionarSerie(int index, Serie serie) {
    setState(() {
      if (index == 1) {
        _serie1 = serie;
      } else {
        _serie2 = serie;
      }
    });
  }

  Future<void> _registrarVitoria(Serie vencedora) async {
    vencedora.vitorias++;
    await _serieController.saveSeries(_series);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${vencedora.nome} venceu a batalha!')),
    );

    setState(() {
      _serie1 = null;
      _serie2 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Batalha de Séries')),
      body: Column(
        children: [
          if (_serie1 != null && _serie2 != null)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSerieCard(_serie1!),
                        _buildSerieCard(_serie2!),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Espaço entre os botões e as séries
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _registrarVitoria(_serie1!),
                        child: Text('Vencedor: ${_serie1!.nome}'),
                      ),
                      SizedBox(height: 10), // Espaço entre os botões
                      ElevatedButton(
                        onPressed: () => _registrarVitoria(_serie2!),
                        child: Text('Vencedor: ${_serie2!.nome}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _series.length,
              itemBuilder: (context, index) {
                final serie = _series[index];
                return ListTile(
                  title: Text(serie.nome),
                  onTap: () {
                    if (_serie1 == null) {
                      _selecionarSerie(1, serie);
                    } else {
                      _selecionarSerie(2, serie);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSerieCard(Serie serie) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: kIsWeb
              ? Image.network(
            serie.capa,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, size: 150, color: Colors.grey);
            },
          )
              : Image.file(
            File(serie.capa),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, size: 150, color: Colors.grey);
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          serie.nome,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text('Gênero: ${serie.genero}'),
        Text(
          'Descrição: ${serie.descricao}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black54),
        ),
        Text('Pontuação: ${serie.pontuacao}'),
        Text('Vitórias: ${serie.vitorias}'),
      ],
    );
  }
}
