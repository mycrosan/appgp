import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

// Enum para tipos de mensagem
enum TipoMensagem { sucesso, erro, aviso, info }

class ListaRelatorio extends StatefulWidget {
  @override
  _ListaRelatorioState createState() => _ListaRelatorioState();
}

class _ListaRelatorioState extends State<ListaRelatorio> {
  bool isDownloading = false;

  DateTime dataInicio;
  DateTime dataFim;
  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // Cores do tema
  static final Color primaryColor = Color(0xFF220055); // Cor principal do tema
  static final Color accentColor = Color(0xFF6A1B9A); // Cor secundária
  static final Color lightColor = Color(0xFFEDE7F6); // Cor clara para fundos

  @override
  void initState() {
    super.initState();
    // Inicializa com os últimos 30 dias
    definirPeriodo(30);
  }

  void definirPeriodo(int dias) {
    final DateTime hoje = DateTime.now();
    setState(() {
      dataFim = hoje;
      dataInicio = hoje.subtract(Duration(days: dias));
    });
  }

  Future<void> selecionarData(BuildContext context, bool isInicio) async {
    final DateTime initialDate =
        isInicio ? dataInicio ?? DateTime.now() : dataFim ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: primaryColor,
              ),
            ),
          ),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          dataInicio = picked;
        } else {
          dataFim = picked;
        }
      });
    }
  }

  // Método para verificar e solicitar permissões de armazenamento
  Future<bool> _verificarPermissoes() async {
    print('Verificando permissões de armazenamento...');
    
    if (Platform.isAndroid) {
      // Verifica o status da permissão de armazenamento
      var status = await Permission.storage.status;
      print('Status atual da permissão: $status');
      
      if (!status.isGranted) {
        print('Solicitando permissão de armazenamento...');
        // Solicita a permissão
        status = await Permission.storage.request();
        print('Novo status da permissão: $status');
        
        if (!status.isGranted) {
          print('Permissão negada pelo usuário');
          _mostrarMensagem(
              'É necessário permitir o acesso ao armazenamento para salvar o arquivo.',
              TipoMensagem.erro);
          return false;
        }
      }
      
      // Para Android 11 ou superior, verificar permissão de gerenciamento de armazenamento externo
      if (Platform.isAndroid) {
        try {
          // Verificamos a permissão de gerenciamento de armazenamento externo para Android 11+
          print('Verificando permissão MANAGE_EXTERNAL_STORAGE');
          var manageStatus = await Permission.manageExternalStorage.status;
          print('Status atual da permissão MANAGE_EXTERNAL_STORAGE: $manageStatus');
          
          if (!manageStatus.isGranted) {
            print('Solicitando permissão MANAGE_EXTERNAL_STORAGE...');
            manageStatus = await Permission.manageExternalStorage.request();
            print('Novo status da permissão MANAGE_EXTERNAL_STORAGE: $manageStatus');
            
            if (!manageStatus.isGranted) {
              print('Permissão MANAGE_EXTERNAL_STORAGE negada pelo usuário');
              // Mostrar mensagem informativa, mas continuar com o fluxo
              _mostrarMensagem(
                  'Para melhor funcionamento, acesse Configurações > Apps > GP PREMIUM > Permissões > Armazenamento e ative "Permitir gerenciamento de todos os arquivos".',
                  TipoMensagem.aviso);
              // Não retornamos false aqui para permitir que o fluxo continue
            }
          }
        } catch (e) {
          print('Erro ao verificar permissões: $e');
          // Ignorar erros de permissão e continuar com o fluxo
        }
      }
    }
    
    return true;
  }

  Future<void> downloadExcel() async {
    print('===== INICIANDO DOWNLOAD EXCEL =====');
    print('Versão do Android: ${Platform.isAndroid ? 'Sim' : 'Não'}');
    print('Versão do iOS: ${Platform.isIOS ? 'Sim' : 'Não'}');
    
    if (dataInicio == null || dataFim == null) {
      print('Erro: Data início ou fim não selecionada');
      _mostrarMensagem('Selecione a data de início e fim', TipoMensagem.aviso);
      return;
    }

    setState(() {
      isDownloading = true;
    });

    // Verifica permissões antes de prosseguir
    if (Platform.isAndroid) {
      print('===== VERIFICANDO PERMISSÕES NO ANDROID =====');
      bool permissaoOk = await _verificarPermissoes();
      print('Resultado da verificação de permissões: ${permissaoOk ? 'OK' : 'Falhou'}');
      if (!permissaoOk) {
        print('Permissões não concedidas, cancelando download');
        setState(() {
          isDownloading = false;
        });
        return;
      }
    }

    try {
      // Monta a URL com query params
      var url = Uri.parse(
        SERVER_IP +
            'download?inicio=${dataInicio.toIso8601String()}&fim=${dataFim.toIso8601String()}',
      );
      
      print('===== FAZENDO REQUISIÇÃO HTTP =====');
      print('URL: $url');
      print('Iniciando download do servidor...');
      var response = await http.get(url);
      print('Status da resposta: ${response.statusCode}');
      print('Tamanho da resposta: ${response.bodyBytes.length} bytes');

      if (response.statusCode == 200) {
        // Formata a data sem barras para evitar problemas no caminho do arquivo
        String dataFormatada = dateFormat.format(DateTime.now()).replaceAll('/', '-');
        String nomeArquivoBase = 'Rel_Producao_${dataFormatada}';
        String nomeArquivo = '$nomeArquivoBase.xlsx';
        print('Nome do arquivo base: $nomeArquivoBase');
        print('Nome do arquivo inicial: $nomeArquivo');

        try {
          print('===== SELECIONANDO DIRETÓRIO =====');
          print('Solicitando ao usuário que escolha o diretório para salvar');
          
          // Solicita ao usuário que escolha o diretório para salvar
          print('Chamando FilePicker.platform.getDirectoryPath()');
          String selectedDirectory = await FilePicker.platform.getDirectoryPath();
          print('Diretório selecionado: $selectedDirectory');
          
          if (selectedDirectory == null) {
            print('Seleção de diretório cancelada pelo usuário');
            _mostrarMensagem('Seleção de diretório cancelada', TipoMensagem.aviso);
            setState(() {
              isDownloading = false;
            });
            return;
          }
          
          // Garantir que o caminho do arquivo seja válido
          String filePath = '$selectedDirectory/$nomeArquivo';
          print('===== SALVANDO ARQUIVO =====');
          print('Caminho do arquivo inicial para salvar: $filePath');
          
          // Verificar se o caminho contém caracteres inválidos
          if (filePath.contains('//') || filePath.contains('\\')) {
            print('Corrigindo caminho com separadores duplicados ou inválidos');
            filePath = filePath.replaceAll('//', '/').replaceAll('\\', '/');
            print('Caminho corrigido: $filePath');
          }
          
          // Salva o arquivo
          print('Criando objeto File...');
          File file = File(filePath);
          print('Verificando se o arquivo já existe...');
          
          // Verificar se o arquivo já existe e adicionar número sequencial
          int contador = 1;
          while (await file.exists()) {
            print('Arquivo já existe, tentando com número sequencial: $contador');
            nomeArquivo = '${nomeArquivoBase}_$contador.xlsx';
            filePath = '$selectedDirectory/$nomeArquivo';
            
            // Verificar e corrigir separadores duplicados ou inválidos
            if (filePath.contains('//') || filePath.contains('\\')) {
              filePath = filePath.replaceAll('//', '/').replaceAll('\\', '/');
            }
            
            file = File(filePath);
            contador++;
            if (contador > 100) {
              // Evitar loop infinito
              print('Limite de tentativas atingido');
              break;
            }
          }
          
          print('Nome final do arquivo: $nomeArquivo');
          print('Caminho final do arquivo: $filePath');
          print('Iniciando gravação dos bytes...');
          
          try {
            // Tenta criar o diretório se não existir
            Directory directory = Directory(selectedDirectory);
            if (!await directory.exists()) {
              print('Diretório não existe, tentando criar...');
              await directory.create(recursive: true);
              print('Diretório criado com sucesso');
            }
            
            // Salva o arquivo usando writeAsBytes
            print('Gravando ${response.bodyBytes.length} bytes no arquivo...');
            await file.writeAsBytes(response.bodyBytes, flush: true);
            print('Arquivo salvo com sucesso em: $filePath');
            
            // Verifica se o arquivo existe e seu tamanho
            bool fileExists = await file.exists();
            print('Arquivo existe após salvar? ${fileExists ? 'Sim' : 'Não'}');
            if (fileExists) {
              print('Tamanho do arquivo salvo: ${await file.length()} bytes');
            }
          } catch (writeError) {
            print('ERRO AO ESCREVER ARQUIVO: $writeError');
            print('Tipo de erro: ${writeError.runtimeType}');
            print('Stack trace: ${StackTrace.current}');
            throw writeError; // Relança o erro para ser capturado pelo catch externo
          }
          
          // Mostra mensagem de sucesso
          _mostrarMensagem(
              'Download concluído com sucesso!\nArquivo salvo em: $filePath',
              TipoMensagem.sucesso);
              
          // Tenta abrir o arquivo
          try {
            print('===== ABRINDO ARQUIVO =====');
            print('Tentando abrir o arquivo...');
            final result = await OpenFile.open(filePath);
            print('Resultado da abertura: ${result.type} - ${result.message}');
            
            if (result.type != ResultType.done) {
              print('Não foi possível abrir o arquivo: ${result.message}');
              _mostrarMensagem(
                  'Arquivo salvo, mas não foi possível abri-lo automaticamente. Você pode encontrá-lo em: $filePath',
                  TipoMensagem.aviso);
            }
          } catch (openError) {
            print('Erro ao abrir o arquivo: $openError');
            print('Tipo de erro ao abrir: ${openError.runtimeType}');
            _mostrarMensagem(
                'Arquivo salvo com sucesso, mas não foi possível abri-lo: $openError\nVocê pode encontrá-lo em: $filePath',
                TipoMensagem.aviso);
          }
        } catch (saveError) {
          print('===== ERRO AO SALVAR ARQUIVO =====');
          print('Erro ao salvar o arquivo: $saveError');
          print('Tipo de erro: ${saveError.runtimeType}');
          print('Tentando usar diretório de fallback...');
          _mostrarMensagem(
              'Erro ao salvar o arquivo: $saveError\nTentando salvar na pasta de documentos...',
              TipoMensagem.erro);

          // Fallback para o diretório de documentos
          try {
            print('Obtendo diretório de documentos do aplicativo...');
            Directory appDocDir = await getApplicationDocumentsDirectory();
            print('Diretório de documentos: ${appDocDir.path}');
            // Garantir que o nome do arquivo não tenha caracteres inválidos para o caminho
            String fallbackPath = '${appDocDir.path}/$nomeArquivo';
            print('Caminho de fallback inicial: $fallbackPath');
             
            // Verificar se o caminho contém caracteres inválidos
            if (fallbackPath.contains('//') || fallbackPath.contains('\\')) {
              print('Corrigindo caminho de fallback com separadores duplicados ou inválidos');
              fallbackPath = fallbackPath.replaceAll('//', '/').replaceAll('\\', '/');
              print('Caminho de fallback corrigido: $fallbackPath');
            }

            print('Criando arquivo de fallback...');
            File fallbackFile = File(fallbackPath);
            
            // Verificar se o arquivo já existe e adicionar número sequencial
            int contador = 1;
            while (await fallbackFile.exists()) {
              print('Arquivo de fallback já existe, tentando com número sequencial: $contador');
              nomeArquivo = '${nomeArquivoBase}_$contador.xlsx';
              fallbackPath = '${appDocDir.path}/$nomeArquivo';
              
              // Verificar e corrigir separadores duplicados ou inválidos
              if (fallbackPath.contains('//') || fallbackPath.contains('\\')) {
                fallbackPath = fallbackPath.replaceAll('//', '/').replaceAll('\\', '/');
              }
              
              fallbackFile = File(fallbackPath);
              contador++;
              if (contador > 100) {
                // Evitar loop infinito
                print('Limite de tentativas atingido');
                break;
              }
            }
            
            print('Nome final do arquivo de fallback: $nomeArquivo');
            print('Caminho final do arquivo de fallback: $fallbackPath');
            print('Gravando bytes no arquivo de fallback...');
            await fallbackFile.writeAsBytes(response.bodyBytes);
            print('Arquivo salvo com sucesso no diretório de fallback');
            print('Tamanho do arquivo de fallback: ${await fallbackFile.length()} bytes');

            _mostrarMensagem(
                'Arquivo salvo na pasta de documentos: $fallbackPath',
                TipoMensagem.sucesso);

            try {
              print('Tentando abrir o arquivo de fallback...');
              final fallbackResult = await OpenFile.open(fallbackPath);
              print('Resultado da abertura do fallback: ${fallbackResult.type} - ${fallbackResult.message}');
              
              if (fallbackResult.type != ResultType.done) {
                print('Não foi possível abrir o arquivo de fallback: ${fallbackResult.message}');
                _mostrarMensagem(
                    'Arquivo salvo, mas não foi possível abri-lo: ${fallbackResult.message}',
                    TipoMensagem.aviso);
              }
            } catch (openError) {
              print('Erro ao abrir o arquivo de fallback: $openError');
              print('Tipo de erro ao abrir fallback: ${openError.runtimeType}');
              _mostrarMensagem(
                  'Arquivo salvo, mas não foi possível abri-lo: $openError',
                  TipoMensagem.aviso);
            }
          } catch (fallbackError) {
            print('ERRO CRÍTICO: Falha ao salvar no diretório de fallback: $fallbackError');
            print('Tipo de erro no fallback: ${fallbackError.runtimeType}');
            _mostrarMensagem(
                'Não foi possível salvar o arquivo em nenhum local: $fallbackError',
                TipoMensagem.erro);
          }
        }
      } else {
        print('Erro na resposta HTTP: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        _mostrarMensagem(
            'Erro ao baixar o arquivo (Status: ${response.statusCode})',
            TipoMensagem.erro);
      }
    } catch (e) {
      print('===== ERRO GERAL NO DOWNLOAD =====');
      print('Erro ao fazer download: $e');
      print('Tipo de erro: ${e.runtimeType}');
      _mostrarMensagem('Erro ao fazer download: $e', TipoMensagem.erro);
    } finally {
      print('===== FINALIZANDO DOWNLOAD EXCEL =====');
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem, TipoMensagem tipo) {
    // Limpa qualquer snackbar existente
    ScaffoldMessenger.of(context).clearSnackBars();
    
    // Mostra a nova mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIconForTipo(tipo),
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                mensagem,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForTipo(tipo),
        duration: Duration(seconds: tipo == TipoMensagem.erro ? 8 : 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Color _getColorForTipo(TipoMensagem tipo) {
    switch (tipo) {
      case TipoMensagem.sucesso:
        return Colors.green;
      case TipoMensagem.erro:
        return Colors.red;
      case TipoMensagem.aviso:
        return Colors.orange;
      case TipoMensagem.info:
        return primaryColor;
      default:
        return primaryColor;
    }
  }

  IconData _getIconForTipo(TipoMensagem tipo) {
    switch (tipo) {
      case TipoMensagem.sucesso:
        return Icons.check_circle;
      case TipoMensagem.erro:
        return Icons.error;
      case TipoMensagem.aviso:
        return Icons.warning;
      case TipoMensagem.info:
        return Icons.info;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Produção'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    'Gerar Relatório de Produção',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Seleção de período
                  Text(
                    'Selecione o período:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Botões de período rápido
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildPeriodButton('Últimos 7 dias', 7),
                      _buildPeriodButton('Últimos 15 dias', 15),
                      _buildPeriodButton('Últimos 30 dias', 30),
                      _buildPeriodButton('Últimos 90 dias', 90),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Seleção de data personalizada
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          label: 'Data Início',
                          date: dataInicio,
                          icon: Icons.calendar_today,
                          onTap: () => selecionarData(context, true),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateSelector(
                          label: 'Data Fim',
                          date: dataFim,
                          icon: Icons.calendar_today,
                          onTap: () => selecionarData(context, false),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Botão de download
                  Container(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: isDownloading ? null : downloadExcel,
                      icon: isDownloading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.download, size: 24),
                      label: Text(
                        isDownloading
                            ? 'Baixando...'
                            : 'Baixar Relatório Excel',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Texto informativo
                  Text(
                    'O relatório será gerado em formato Excel (.xlsx)',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, int dias) {
    bool isSelected = false;

    if (dataInicio != null && dataFim != null) {
      final difference = dataFim.difference(dataInicio).inDays;
      isSelected = (difference >= dias - 1 && difference <= dias + 1);
    }

    return ElevatedButton(
      onPressed: () => definirPeriodo(dias),
      child: Text(label),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? primaryColor : lightColor,
        onPrimary: isSelected ? Colors.white : primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: primaryColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    String label,
    DateTime date,
    IconData icon,
    Function onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  date != null ? dateFormat.format(date) : 'Selecionar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: date != null ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
