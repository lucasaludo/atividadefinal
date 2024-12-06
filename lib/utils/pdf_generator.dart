import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/serie.dart';

Future<void> gerarRelatorioPDF(List<Serie> series) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: series.map((serie) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 16.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Nome: ${serie.nome}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                  ),
                  pw.Text('Gênero: ${serie.genero}'),
                  pw.Text('Descrição: ${serie.descricao}'),
                  pw.Text('Pontuação: ${serie.pontuacao}'),
                  pw.Text('Vitórias: ${serie.vitorias}'),
                  pw.Divider(), // Linha separadora
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}
