# Установка mise

## Установка

```bash
curl https://mise.run | sh
```

После этого бинарник будет лежать в `~/.local/bin/mise`.

## Подключение к shell

Чтобы mise работал автоматически при переходе между папками — нужно добавить hook в конфиг shell.

**Bash** (`~/.bashrc`):
```bash
eval "$(~/.local/bin/mise activate bash)"
```

**Zsh** (`~/.zshrc`):
```zsh
eval "$(~/.local/bin/mise activate zsh)"
```

После добавления перезапусти терминал или выполни:
```bash
source ~/.bashrc  # или ~/.zshrc
```

## Проверка

```bash
mise --version
# mise 2026.6.0
```

Зайди в папку проекта где есть `mise.toml` и проверь что инструменты подхватились:

```bash
mise current
# bun     1.2.0  mise.toml
# fnox    1.25.1 mise.toml
```

## Установка инструментов из mise.toml

Когда клонируешь репозиторий впервые — mise сами инструменты не скачивает. Нужно явно установить:

```bash
mise install
```

После этого все инструменты из `mise.toml` будут доступны в этом проекте.
