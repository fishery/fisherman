[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: https://github.com/fisherman.sh
[организации]: https://github.com/fisherman
[онлайн]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: ../es-ES
[简体中文]: ../zh-CN
[日本語]: ../jp-JA
[Русский]: ../ru-RU
[한국어]: ../ko-KR
[Català]: ../ca-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman это параллельный менеджер плагинов для [fish shell].

Прочитать этот документ на другом языке: [English], [Español], [日本語], [简体中文], [한국어], [Català].

## Достоинства fisherman

* Не нужно настраивать

* Нет внешних зависимостей

* Не влияет на время запуска оболочки

* Можно использовать в интерактивном режиме или а-ля vundle

* Только необходимые функции: установка, обновление, удаление, список установленного и справка

## Установка

Используя curl:

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

Используя npm:

```sh
npm i -g fisherman
```

Если вы ещё используете версию 1.5 и хотите обновиться до >2.0 без особых хлопот:

```
curl -L git.io/fisher-up-me | fish
```

## Использование

Установка отдельного плагина.

```
fisher simple
```

Установка из нескольких источников.

```
fisher z fzf omf/{grc,thefuck}
```

Установка по ссылке URL.

```
fisher https://github.com/edc/bass
```

Установка из gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Установка из локального каталога.

```sh
fisher ~/my_aliases
```

Использование в интерактивном-режиме. Отредактируйте fishfile и запустите `fisher`, чтобы изменения вступили в силу.

> [Что такое fishfile и как я могу его использовать?](#6-Что-такое-fishfile-и-как-я-могу-его-использовать)

```sh
$EDITOR fishfile # добавьте плагины
fisher
```

Просмотр установленных плагинов.

```
fisher ls
@ my_aliases    # этот плагин представляет собой локальный каталог
* simple        # этот плагин является текущим оформлением командной строки
  bass
  fzf
  grc
  thefuck
  z
```

Обновление всего сразу.

```
fisher up
```

Обновление отдельных плагинов.

```
fisher up bass z fzf thefuck
```

Удаление плагинов.

```
fisher rm simple
```

Удаление всех плагинов.

```
fisher ls | fisher rm
```

Справка по плагину.

```
fisher help z
```

## Часто задаваемые вопросы

### 1. Какая версия fish необходима?

fisherman был разработан для fish >= 2.3.0. Если вы используете 2.2.0, добавьте следующий код в ваш `~/.config/fish/config.fish` для поддержки [cниппетов](#8-Что-такое-плагин).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. Как сделать fish основной командной оболочкой?

Добавьте fish в список командных оболочек `/etc/shells` и сделайте её оболочкой по умолчанию.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. Как мне удалить fisherman?

```fish
fisher self-uninstall
```

или

```fish
npm un -g fisherman
```

### 4. Совместим ли fisherman с темами и плагинами oh my fish?

Да.

### 5. Где fisherman хранит данные?

Скрипт fisherman находится в `~/.config/fish/functions/fisher.fish`.

Кэш и настройки плагинов создаются в `~/.cache/fisherman` и `~/.config/fisherman` соответственно.

fishfile сохраняется в `~/.config/fish/fishfile`.

### 6. Что такое fishfile и как я могу его использовать?

В `~/.config/fish/fishfile` хранится список всех установленных плагинов.

fisherman обновляет этот файл автоматически, но вы также можете добавить плагины в список вручную и запустить `fisher`, чтобы эти изменения вступили в силу.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

Этот механизм только устанавливает плагины и отсутствующие зависимости. Чтобы удалить плагин, используйте `fisher rm`.

### 7. Где я могу найти список плагинов для fish?

Используйте поиск по Github [организации] или [онлайн] поиск на сайте.

### 8. Что такое плагин?

Плагином является:

1. каталог или git репозиторий с файлом `.fish` либо на корневом уровне проекта, либо в директории `functions`

2. тема или оформление командной строки, т.е. `fish_prompt.fish`, `fish_right_prompt.fish` или оба файла

3. сниппет, т.е. один или несколько `.fish` файлов в директории `conf.d`, которые fish читает при запуске

### 9. Как я могу объявить зависимости моего плагина?

Создайте новый `fishfile` в корне вашего проекта со списком зависимостей.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
