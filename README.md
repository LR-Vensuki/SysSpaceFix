# SysSpaceFix

Пакет для джейлбрейкнутых **iOS 4.0 – 7.x**, который освобождает системный
раздел: тяжёлые каталоги твиков и тем переносятся на раздел данных, в
`/private/var/stash/SysSpaceFix`, а на их месте остаются символические ссылки.
dpkg ходит по таким ссылкам, поэтому твики, поставленные позже, тоже попадают на
раздел данных.

Разработчик — **LegacyReborn Project**.

**Установка**: Cydia-репозиторий LegacyReborn — `http://repo.legacyreborn.cfd/`
(пакет `com.legacyreborn.sysspacefix`), или `.deb` со
[страницы релизов](https://github.com/LR-Vensuki/SysSpaceFix/releases).

## Что переносится

`/Applications`, `/Library/Themes`, `/Library/Wallpaper`, `/Library/Ringtones`,
`/Library/Application Support`, `/Library/PreferenceBundles`, `/Library/SBSettings`,
`/Library/Zeppelin`, `/usr/share`, `/usr/include`, `/usr/local`, а также каталоги из
`/private/var/lib/sysspacefix/extra.list` (по одному на строку). Каталоги меньше
256 КБ не трогаются.

Никогда не переносятся системные пути (`/System`, `/bin`, `/usr/lib`, `/etc`…),
MobileSubstrate, LaunchDaemons/LaunchAgents, PreferenceLoader и каталоги с файлами
пакетов джейлбрейка и untether (p0sixspwn, evasi0n, absinthe, pangu и т.д.): всё,
что нужно для загрузки и для работы shell и dpkg.

## Как это работает

- `postinst` переносит каталоги сразу после установки; хук APT
  (`/etc/apt/apt.conf.d/90sysspacefix`) повторяет это после каждой работы dpkg.
- Каталог сначала копируется, копия сверяется по числу файлов, и только потом
  оригинал заменяется ссылкой. Прерванный перенос (сбой, отключение питания)
  при следующем запуске доводится до конца или откатывается.
- На разделе данных всегда остаётся не меньше 50 МБ.
- `prerm` возвращает всё на системный раздел. Если места не хватает, удаление
  пакета отменяется и ничего не меняется.
- Если что-то было перенесено или возвращено, Cydia просит перезагрузку.

## Команды

От root:

```sh
sysspacefix status      # что перенесено и сколько места на разделах
sysspacefix stash       # перенести
sysspacefix restore     # вернуть всё на системный раздел
sysspacefix top [N]     # крупнейшие каталоги системного раздела
```

Журнал — `/private/var/lib/sysspacefix/log.txt`.

## Сборка

Нужен [Theos](https://theos.dev); компилировать нечего, пакет — это скрипты из
`layout/`.

```sh
make package FINALPACKAGE=1   # packages/com.legacyreborn.sysspacefix_<версия>_iphoneos-arm.deb
```

Пакет сжимается gzip: dpkg на iOS 4–7 не умеет xz и zstd. Зависимости: `bash`,
`coreutils`, `findutils`, `grep`.

## Структура

```
control                              метаданные пакета
layout/usr/bin/sysspacefix           перенос и возврат каталогов
layout/etc/apt/apt.conf.d/90sysspacefix  хук APT: перенос после каждой работы dpkg
layout/DEBIAN/{postinst,prerm,postrm}    перенос при установке, возврат при удалении
depiction/                           описание пакета для Cydia-репозитория
```
