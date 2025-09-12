import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Serviço moderno para impressão fiscal compatível com Flutter 3
/// Substitui as dependências esc_pos que causavam conflitos
class ImpressaoFiscalService {
  
  /// Gera um cupom fiscal em PDF para impressão
  /// 
  /// Complexidade: O(n) onde n é o número de itens
  /// Espaço: O(1) - uso constante de memória
  static Future<Uint8List> gerarCupomFiscal({
    required String numeroNota,
    required String cliente,
    required List<ItemVenda> itens,
    required double total,
    DateTime? dataVenda,
  }) async {
    final pdf = pw.Document();
    final data = dataVenda ?? DateTime.now();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Formato para impressora fiscal
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              pw.Center(
                child: pw.Text(
                  'GP PREMIUM',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              
              // Informações da nota
              pw.Text('Nota Fiscal: $numeroNota'),
              pw.Text('Cliente: $cliente'),
              pw.Text('Data: ${_formatarData(data)}'),
              pw.Divider(),
              
              // Itens
              pw.Text(
                'ITENS',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              
              // Lista de itens - O(n) complexidade
              ...itens.map((item) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(item.descricao),
                  ),
                  pw.Expanded(
                    child: pw.Text('${item.quantidade}x'),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'R\$ ${item.valor.toStringAsFixed(2)}',
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              )),
              
              pw.Divider(),
              
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Obrigado pela preferência!',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Imprime o cupom fiscal
  /// 
  /// Complexidade: O(1) - operação constante
  /// Espaço: O(1) - uso constante de memória
  static Future<void> imprimirCupom({
    required String numeroNota,
    required String cliente,
    required List<ItemVenda> itens,
    required double total,
    DateTime? dataVenda,
  }) async {
    try {
      final pdfData = await gerarCupomFiscal(
        numeroNota: numeroNota,
        cliente: cliente,
        itens: itens,
        total: total,
        dataVenda: dataVenda,
      );
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
        name: 'Cupom_Fiscal_$numeroNota',
      );
    } catch (e) {
      throw ImpressaoException('Erro ao imprimir cupom: $e');
    }
  }
  
  /// Compartilha o cupom fiscal via sistema
  /// 
  /// Complexidade: O(1) - operação constante
  /// Espaço: O(1) - uso constante de memória
  static Future<void> compartilharCupom({
    required String numeroNota,
    required String cliente,
    required List<ItemVenda> itens,
    required double total,
    DateTime? dataVenda,
  }) async {
    try {
      final pdfData = await gerarCupomFiscal(
        numeroNota: numeroNota,
        cliente: cliente,
        itens: itens,
        total: total,
        dataVenda: dataVenda,
      );
      
      await Printing.sharePdf(
        bytes: pdfData,
        filename: 'Cupom_Fiscal_$numeroNota.pdf',
      );
    } catch (e) {
      throw ImpressaoException('Erro ao compartilhar cupom: $e');
    }
  }
  
  /// Formata data para exibição no cupom
  /// 
  /// Complexidade: O(1) - operação constante
  /// Espaço: O(1) - uso constante de memória
  static String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
           '${data.month.toString().padLeft(2, '0')}/'
           '${data.year} '
           '${data.hour.toString().padLeft(2, '0')}:'
           '${data.minute.toString().padLeft(2, '0')}';
  }
}

/// Modelo para itens de venda
/// 
/// Aplicando SOLID: Single Responsibility Principle
/// Esta classe tem apenas a responsabilidade de representar um item de venda
class ItemVenda {
  final String descricao;
  final int quantidade;
  final double valor;
  
  const ItemVenda({
    required this.descricao,
    required this.quantidade,
    required this.valor,
  });
  
  /// Factory constructor para criar a partir de JSON
  /// 
  /// Complexidade: O(1) - operação constante
  factory ItemVenda.fromJson(Map<String, dynamic> json) {
    return ItemVenda(
      descricao: json['descricao'] as String,
      quantidade: json['quantidade'] as int,
      valor: (json['valor'] as num).toDouble(),
    );
  }
  
  /// Converte para JSON
  /// 
  /// Complexidade: O(1) - operação constante
  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'quantidade': quantidade,
      'valor': valor,
    };
  }
}

/// Exceção customizada para erros de impressão
/// 
/// Aplicando SOLID: Single Responsibility Principle
/// Esta classe tem apenas a responsabilidade de representar erros de impressão
class ImpressaoException implements Exception {
  final String message;
  
  const ImpressaoException(this.message);
  
  @override
  String toString() => 'ImpressaoException: $message';
}
