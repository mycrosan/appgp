#!/bin/bash

# Script de configuração do projeto GPPremium
# Este script configura o ambiente de desenvolvimento usando FVM e SDKMAN

echo "🚀 Configurando ambiente de desenvolvimento para GPPremium..."

# Verificar se FVM está instalado
if ! command -v fvm &> /dev/null; then
    echo "❌ FVM não encontrado. Instale o FVM primeiro:"
    echo "dart pub global activate fvm"
    exit 1
fi

# Verificar se SDKMAN está instalado
if ! command -v sdk &> /dev/null; then
    echo "❌ SDKMAN não encontrado. Instale o SDKMAN primeiro:"
    echo "curl -s \"https://get.sdkman.io\" | bash"
    exit 1
fi

# Configurar versão do Java usando SDKMAN
echo "📦 Configurando Java 11.0.28-tem..."
sdk env

# Verificar versão do Java
echo "☕ Versão do Java:"
java -version

# Configurar Flutter usando FVM
echo "🎯 Usando Flutter 3.0.5 via FVM..."
fvm use 3.0.5

# Verificar versão do Flutter
echo "🐦 Versão do Flutter:"
fvm flutter --version

# Limpar e obter dependências
echo "🧹 Limpando projeto..."
fvm flutter clean

echo "📦 Obtendo dependências..."
fvm flutter pub get

# Verificar configuração
echo "🔍 Verificando configuração do Flutter..."
fvm flutter doctor

echo "✅ Configuração concluída!"
echo ""
echo "Para usar o projeto:"
echo "1. Execute 'sdk env' para configurar o Java"
echo "2. Use 'fvm flutter' em vez de 'flutter' para comandos"
echo "3. Para executar: 'fvm flutter run'"
echo ""
