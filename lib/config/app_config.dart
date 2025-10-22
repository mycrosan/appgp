import 'dart:io';
import 'package:flutter/services.dart';

/// Configurações do aplicativo
///
/// Este arquivo centraliza as informações de versão e configurações
/// do aplicativo, lendo dinamicamente do pubspec.yaml
class AppConfig {
  static String _version;
  static String _buildNumber;

  // Nome do aplicativo
  static const String appName = 'GPPremium';

  // Descrição do aplicativo
  static const String appDescription = 'Aplicativo GP';

  /// Lê a versão do pubspec.yaml dinamicamente
  static Future<void> _loadVersionFromPubspec() async {
    if (_version != null && _buildNumber != null) return;

    try {
      // Tenta ler o pubspec.yaml do bundle de assets
      String pubspecContent = await rootBundle.loadString('pubspec.yaml');

      // Procura pela linha da versão
      final lines = pubspecContent.split('\n');
      for (String line in lines) {
        if (line.trim().startsWith('version:')) {
          final versionLine = line.split(':')[1].trim();
          final parts = versionLine.split('+');

          if (parts.length == 2) {
            _version = parts[0];
            _buildNumber = parts[1];
          } else {
            _version = versionLine;
            _buildNumber = '1';
          }
          break;
        }
      }
    } catch (e) {
      // Fallback para versão padrão em caso de erro
      _version = '0.0.0';
      _buildNumber = '0';
    }

    // Se não encontrou a versão, usa fallback
    if (_version == null) _version = '1.7.1';
    if (_buildNumber == null) _buildNumber = '18';
  }

  /// Retorna a versão do aplicativo
  static Future<String> get version async {
    await _loadVersionFromPubspec();
    return _version;
  }

  /// Retorna o número de build
  static Future<String> get buildNumber async {
    await _loadVersionFromPubspec();
    return _buildNumber;
  }

  /// Versão formatada para exibição
  static Future<String> get formattedVersion async {
    await _loadVersionFromPubspec();
    return 'v$_version+$_buildNumber';
  }
}
