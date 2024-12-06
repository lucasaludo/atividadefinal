import 'package:flutter/material.dart';
import '../utils/pdf_generator.dart';
import '../controllers/serie_controller.dart';

class RelatorioView extends StatelessWidget {
  final SerieController controller = SerieController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerar Relatório')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final series = await controller.getSeries();
            await gerarRelatorioPDF(series);
          },
          child: Text('Gerar PDF'),
        ),
      ),
    );
  }
}
