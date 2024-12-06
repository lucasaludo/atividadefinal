import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/serie.dart';
import '../controllers/serie_controller.dart';

class EditarSerieView extends StatefulWidget {
  final Serie serie;

  EditarSerieView({required this.serie});

  @override
  _EditarSerieViewState createState() => _EditarSerieViewState();
}

class _EditarSerieViewState extends State<EditarSerieView> {
  late TextEditingController _nomeController;
  late TextEditingController _generoController;
  late TextEditingController _descricaoController;
  String? _imagemUrl;
  double _pontuacao = 5;
  final _serieController = SerieController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.serie.nome);
    _generoController = TextEditingController(text: widget.serie.genero);
    _descricaoController = TextEditingController(text: widget.serie.descricao);
    _imagemUrl = widget.serie.capa;
    _pontuacao = widget.serie.pontuacao.toDouble();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imagemUrl = result.files.single.path;
      });
    }
  }

  Future<void> _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      widget.serie.nome = _nomeController.text;
      widget.serie.genero = _generoController.text;
      widget.serie.descricao = _descricaoController.text;
      widget.serie.capa = _imagemUrl ?? '';
      widget.serie.pontuacao = _pontuacao.toInt();

      final series = await _serieController.getSeries();
      final index = series.indexWhere((s) => s.id == widget.serie.id);
      if (index != -1) {
        series[index] = widget.serie;
        await _serieController.saveSeries(series);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Série editada com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Série')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome da Série'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o nome' : null,
                ),
                TextFormField(
                  controller: _generoController,
                  decoration: InputDecoration(labelText: 'Gênero'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o gênero' : null,
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe a descrição' : null,
                ),
                SizedBox(height: 20),
                Text(
                  'Pontuação (1-10): ${_pontuacao.toInt()}',
                  style: TextStyle(fontSize: 16),
                ),
                Slider(
                  value: _pontuacao,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _pontuacao.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _pontuacao = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Selecionar Nova Capa'),
                ),
                if (_imagemUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.network(
                      _imagemUrl!,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvarEdicao,
                  child: Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
