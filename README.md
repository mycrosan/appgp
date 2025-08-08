# gp_app
App para gestão de carcaças

# Descrição
Sistema Exclusivo GP Premium

## Build
flutter build appbundle

### Commit type	Emoji

- Initial commit	🎉 :tada:
- Version tag	🔖 :bookmark:
- New feature	✨ :sparkles:
- Bugfix	🐛 :bug:
- Metadata	📇 :card_index:
- Documentation	📚 :books:
- Documenting source code	💡 :bulb:
- Performance	🐎 :racehorse:
- Cosmetic	💄 :lipstick:
- Tests	🚨 :rotating_light:
- Adding a test	✅ :white_check_mark:
- Make a test pass	✔️ :heavy_check_mark:
- General update	⚡ :zap:
- Improve format/structure	🎨 :art:
- Refactor code	🔨 :hammer:
- Removing code/files	🔥 :fire:
- Continuous Integration	💚 :green_heart:
- Security	🔒 :lock:
- Upgrading dependencies	⬆️ :arrow_up:
- Downgrading dependencies	⬇️ :arrow_down:
- Lint	👕 :shirt:
- Translation	👽 :alien:
- Text	📝 :pencil:
- Critical hotfix	🚑 :ambulance:
- Deploying stuff	🚀 :rocket:
- Fixing on MacOS	🍎 :apple:
- Fixing on Linux	🐧 :penguin:
- Fixing on Windows	🏁 :checkered_flag:
- Work in progress	🚧 :construction:
- Adding CI build system	👷 :construction_worker:
- Analytics or tracking code	📈 :chart_with_upwards_trend:
- Removing a dependency	➖ :heavy_minus_sign:
- Adding a dependency	➕ :heavy_plus_sign:
- Docker	🐳 :whale:
- Configuration files	🔧 :wrench:
- Package.json in JS	📦 :package:
- Merging branches	🔀 :twisted_rightwards_arrows:
- Bad code / need improv.	💩 :hankey:
- Reverting changes	⏪ :rewind:
- Breaking changes	💥 :boom:
- Code review changes	👌 :ok_hand:
- Accessibility	♿ :wheelchair:
- Move/rename repository	🚚 :truck:

## Comandos para iniciar o AVD - Emulador
- cd ~/Library/Android/sdk/emulator
- ./emulator -avd Pixel_5_API_30   

## Gerar keystore

keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

## build

flutter build apk --release

## Publicar google play console

```bash
 fvm global 2.10.5
```
## flutter build appbundle --release

Launched DevTools manually from terminal dart devtools
After that run the web app flutter run -d 11836f8
Copied the debug service listener URL to DevTools server.


