import 'package:flutter/material.dart';
import '../controllers/serie_controller.dart';
import '../models/serie.dart';

class ListaSeriesView extends StatefulWidget {
  @override
  _ListaSeriesViewState createState() => _ListaSeriesViewState();
}

class _ListaSeriesViewState extends State<ListaSeriesView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Séries')),
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
                subtitle: Text(serie.descricao, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Text(
                  '${serie.vitorias} Vitórias',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
