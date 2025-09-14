# GPPremium - Configuração do Ambiente de Desenvolvimento

Este projeto Flutter usa **FVM** para gerenciar versões do Flutter e **SDKMAN** para gerenciar versões do Java.

## 📋 Pré-requisitos

- **FVM** instalado: `dart pub global activate fvm`
- **SDKMAN** instalado: `curl -s "https://get.sdkman.io" | bash`

## 🚀 Configuração Rápida

Execute o script de configuração:

```bash
./setup.sh
```

## 🔧 Configuração Manual

### 1. Configurar Java (SDKMAN)

```bash
# Instalar Java 11
sdk install java 11.0.28-tem

# Usar Java 11 no projeto atual
sdk env
```

### 2. Configurar Flutter (FVM)

```bash
# Instalar Flutter 3.0.5
fvm install 3.0.5

# Usar Flutter 3.0.5 no projeto
fvm use 3.0.5

# Obter dependências
fvm flutter pub get
```

## 📱 Executando o Projeto

### Para desenvolvimento:
```bash
# Sempre use 'fvm flutter' em vez de 'flutter'
fvm flutter run
```

### Para build Android:
```bash
fvm flutter build apk --release
```

### Para build iOS:
```bash
fvm flutter build ios --release
```

## 🔍 Verificar Configuração

```bash
# Verificar Flutter Doctor
fvm flutter doctor

# Verificar versão do Java
java -version

# Verificar versão do Flutter
fvm flutter --version
```

## 📁 Arquivos de Configuração

- `.fvm/fvm_config.json` - Configuração do FVM (Flutter 3.0.5)
- `.sdkmanrc` - Configuração do SDKMAN (Java 11.0.28-tem)
- `.fvmrc` - Configuração global do FVM

## ⚠️ Notas Importantes

1. **Sempre use `fvm flutter`** em vez de `flutter` diretamente
2. **Execute `sdk env`** ao abrir um novo terminal para configurar o Java
3. O projeto foi atualizado do Flutter 2.10.5 para 3.0.5 para compatibilidade com Apple Silicon
4. Algumas dependências podem mostrar avisos de deprecated, mas são funcionais

## 🐛 Problemas Comuns

### Plugin wifi deprecated
O plugin `wifi` usa uma versão deprecated do Android embedding. Isso não afeta a funcionalidade, mas pode ser atualizado futuramente.

### Android SDK issues
Se houver problemas com Android SDK, certifique-se de ter o Android Studio instalado e configurado corretamente.

## 📞 Comandos Úteis

```bash
# Limpar projeto
fvm flutter clean

# Obter dependências
fvm flutter pub get

# Executar em modo debug
fvm flutter run

# Executar em modo release
fvm flutter run --release

# Build para Android
fvm flutter build apk

# Verificar dispositivos conectados
fvm flutter devices
```
