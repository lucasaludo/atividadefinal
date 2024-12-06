import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import '../models/serie.dart';
import '../controllers/serie_controller.dart';

class CadastroView extends StatefulWidget {
  @override
  _CadastroViewState createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _nomeController = TextEditingController();
  final _generoController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _imagemUrl;
  double _pontuacao = 5; // Valor inicial do slider
  final _serieController = SerieController();
  final _formKey = GlobalKey<FormState>();

  Future<String?> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        // Caminho do arquivo selecionado
        final selectedFile = File(result.files.single.path!);

        // Carrega a imagem e redimensiona para 300x300 pixels
        final imageBytes = selectedFile.readAsBytesSync();
        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage != null) {
          // Redimensionar a imagem para 300x300
          final resizedImage = img.copyResize(decodedImage, width: 300, height: 300);

          // Diretório onde a imagem será salva
          final appDir = await getApplicationDocumentsDirectory();
          final imagesDir = Directory('${appDir.path}/assets_images');
          if (!imagesDir.existsSync()) {
            imagesDir.createSync();
          }

          // Caminho final da imagem
          final savedImagePath = '${imagesDir.path}/${result.files.single.name}';
          final savedImage = File(savedImagePath);

          // Salvar a imagem redimensionada no caminho final
          savedImage.writeAsBytesSync(img.encodeJpg(resizedImage));

          // Atualiza o caminho da imagem salva
          setState(() {
            _imagemUrl = savedImagePath;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Capa selecionada com sucesso!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar a imagem: $e')),
      );
    }
    return null;
  }

  Future<void> _salvarSerie() async {
    if (_formKey.currentState!.validate()) {
      final serie = Serie(
        id: const Uuid().v4(),
        nome: _nomeController.text,
        genero: _generoController.text,
        descricao: _descricaoController.text,
        capa: _imagemUrl ??
            'assets/images/placeholder.jpg', // Caminho da imagem padrão
        pontuacao: _pontuacao.toInt(),
      );

      final series = await _serieController.getSeries();
      series.add(serie);
      await _serieController.saveSeries(series);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Série cadastrada com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Série')),
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
                  child: Text('Selecionar Capa'),
                ),
                if (_imagemUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.file(
                      File(_imagemUrl!),
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvarSerie,
                  child: Text('Salvar Série'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
