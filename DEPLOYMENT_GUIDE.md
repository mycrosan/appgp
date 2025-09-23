# 🚀 Guia de Deploy - GPPremium

## ✅ Status do Projeto
- **Flutter**: 3.0.5 (via FVM)
- **Java**: 11.0.28-tem (via SDKMAN)
- **Build Status**: ✅ APK Debug compilado com sucesso
- **Tempo de Build**: ~7 minutos

## 📱 Builds Disponíveis

### Android APK
```bash
# Debug APK (para testes)
fvm flutter build apk --debug

# Release APK (para produção)
fvm flutter build apk --release

# APK com split por arquitetura (menor tamanho)
fvm flutter build apk --split-per-abi
```

### Android App Bundle (Recomendado para Play Store)
```bash
# App Bundle para Play Store
fvm flutter build appbundle --release
```

### Web
```bash
# Build para web
fvm flutter build web --release
```

## 🔧 Configurações de Deploy

### Variáveis de Ambiente
Certifique-se de configurar:
- `JAVA_HOME` (gerenciado pelo SDKMAN)
- `ANDROID_HOME` (SDK Android)
- `FLUTTER_ROOT` (gerenciado pelo FVM)

### Assinatura do APK
O projeto está configurado para usar `key.properties`:
```properties
storePassword=sua_senha_da_keystore
keyPassword=sua_senha_da_chave
keyAlias=sua_chave_alias
storeFile=caminho/para/sua/keystore.jks
```

## 📋 Checklist de Deploy

### Antes do Deploy
- [ ] Execute `sdk env` para configurar Java
- [ ] Execute `fvm flutter clean`
- [ ] Execute `fvm flutter pub get`
- [ ] Teste em dispositivo/emulador
- [ ] Verifique `flutter doctor`

### Para Play Store
- [ ] Build com `--release`
- [ ] Use App Bundle (`appbundle`)
- [ ] Teste em dispositivos reais
- [ ] Verifique permissões no `AndroidManifest.xml`
- [ ] Configure ProGuard se necessário

### Para Distribuição Interna
- [ ] Build APK debug para testes
- [ ] Build APK release para produção
- [ ] Teste instalação manual

## 🐛 Problemas Conhecidos

### Warnings Durante Build
- Plugin `wifi` usa Android embedding deprecated (não afeta funcionalidade)
- Algumas dependências mostram warnings de null safety (compatibilidade)

### Soluções
- Warnings são esperados devido à migração Flutter 2 → 3
- Funcionalidade não é afetada
- Considere atualizar dependências futuramente

## 📊 Métricas do Build
- **Tamanho APK Debug**: ~50MB (estimado)
- **Tempo de Build**: 6-8 minutos
- **Arquiteturas**: arm64-v8a, armeabi-v7a, x86_64

## 🔄 CI/CD Sugerido

### GitHub Actions
```yaml
- name: Setup Java
  uses: actions/setup-java@v3
  with:
    java-version: '11'

- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.0.5'

- name: Build APK
  run: flutter build apk --release
```

## 📞 Comandos Rápidos

```bash
# Setup completo
./setup.sh

# Build rápido para teste
fvm flutter build apk --debug

# Build para produção
fvm flutter build apk --release

# Verificar configuração
fvm flutter doctor -v
```
