# Первый запуск

## 1. Установи mise

mise — менеджер версий инструментов. Он установит всё остальное.

```bash
curl https://mise.run | sh
```

Затем добавь активацию в конфиг своего shell.

**Bash** (`~/.bashrc`):
```bash
eval "$(~/.local/bin/mise activate bash)"
```

**Zsh** (`~/.zshrc`):
```zsh
eval "$(~/.local/bin/mise activate zsh)"
```

Перезапусти терминал или выполни `source ~/.bashrc` / `source ~/.zshrc`.

---

## 2. Клонируй репозиторий

```bash
git clone <repo-url>
cd ingot
```

---

## 3. Установи инструменты проекта

```bash
mise install
```

mise прочитает `mise.toml` и установит все нужные версии инструментов — bun, biome, age, fnox, hk. После этого они будут доступны в этой папке автоматически. Устанавливать biome отдельно через npm/bun не нужно.

Проверь что всё встало:

```bash
mise current
```

---

## 4. Установи git-хуки

```bash
hk install
```

Это пропишет hk в `.git/hooks/`. После этого линтеры и форматтеры будут запускаться автоматически перед каждым коммитом и пушем.

Проверь что хуки настроены правильно:

```bash
hk run pre-commit --plan
```

---

Дальше — [генерация ключа и получение доступа к секретам](./secrets-access.md).
