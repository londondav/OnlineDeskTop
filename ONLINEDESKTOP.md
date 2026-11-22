# OnlineDeskTop

OnlineDeskTop — приложение для удалённого доступа к рабочему столу. Это форк открытого проекта
[RustDesk](https://github.com/rustdesk/rustdesk) (лицензия AGPL-3.0, см. `LICENCE`).
Основа — RustDesk 1.5.3, коммит `8e1433d4a24852302700c4dd54e8b901f350077c` от 21.11.2026.

## Что изменено относительно RustDesk

| Где | Что |
|---|---|
| `libs/hbb_common/src/config.rs` | имя приложения `OnlineDeskTop`; адрес сервера и ключ (`RENDEZVOUS_SERVERS`, `RS_PUB_KEY`) |
| Windows (`flutter/windows/runner`, `Cargo.toml`) | название программы и описание файла |
| macOS (`flutter/macos`, `build.py`, `res/osx-dist.sh`, CI) | пакет `OnlineDeskTop.app` |
| iOS (`flutter/ios/Runner/Info.plist`) | название на экране |
| Android (`flutter/android`) | название, уведомления, `applicationId = com.onlinedesktop.app` (ставится рядом с RustDesk и не конфликтует с ним) |
| Linux (`res/*.desktop`) | название в меню |
| `.github/workflows` | сборка запускается вручную или по тегу, ночные и служебные сборки RustDesk удалены |
| `server/` | готовый сервер: docker-compose, скрипт установки и инструкция |

Названия файлов внутри сборки (`rustdesk.exe`, `librustdesk.dll` и т. п.) остались прежними, чтобы не сломать сборочные скрипты.
Пользователь видит название OnlineDeskTop: при установке на Windows программа копируется в `C:\Program Files\OnlineDeskTop\OnlineDeskTop.exe`.

## Как собрать

Сборка идёт в облаке GitHub Actions. Для публичного репозитория это бесплатно.

1. Создайте на GitHub пустой репозиторий `OnlineDeskTop`, без README.
2. Загрузите в него код:
   ```powershell
   git remote add origin https://github.com/<ваш-логин>/OnlineDeskTop.git
   git push -u origin master
   ```
3. На GitHub откройте **Actions** и включите workflows.
4. Выберите **OnlineDeskTop Release Build → Run workflow**. Сборка займёт примерно 1–2 часа.
5. Готовые файлы появятся в **Releases → nightly**.
   Для версии с номером: `git tag v1.0.0` и `git push origin v1.0.0`.

## Что получится для каждой платформы

| Платформа | Файл | Замечания |
|---|---|---|
| Windows | `.exe` (переносной и установщик), `.msi` | без цифровой подписи SmartScreen предупредит при первом запуске |
| macOS | `.dmg` (Intel и Apple Silicon) | без подписи Apple: правый клик → «Открыть» |
| Linux | `.deb`, `.rpm`, AppImage, Flatpak | |
| Android | `.apk` | разрешите установку из неизвестных источников |
| ChromeOS | Android `.apk` или Linux `.deb` | на Chromebook с Google Play или с включённым Linux |
| iOS | собирается без подписи | чтобы поставить на iPhone, нужен аккаунт Apple Developer (99 $ в год) или AltStore. На iOS можно только управлять другими устройствами, iPhone не показывает свой экран (ограничение Apple) |

## Свой сервер

Инструкция в [server/README.md](server/README.md). Пока сервер не настроен, клиент работает через публичный сервер RustDesk.

## Обновления из RustDesk

```powershell
git remote add upstream https://github.com/rustdesk/rustdesk.git
git fetch upstream master
git merge upstream/master --allow-unrelated-histories
```
Конфликты при слиянии будут в файлах из таблицы выше.
