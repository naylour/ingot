# Конфиг проекта

## Установка хуков

После клонирования репозитория один раз:

```bash
hk install
```

Это пропишет hk в `.git/hooks/`. После этого хуки запускаются автоматически при `git commit`, `git push` и т.д.

## Полный конфиг проекта

```pkl
amends "package://github.com/jdx/hk/releases/download/v1.46.0/hk@1.46.0#/Config.pkl"
import "package://github.com/jdx/hk/releases/download/v1.46.0/hk@1.46.0#/Builtins.pkl"

// Шаги для TS/JS/Svelte/CSS/JSON — переиспользуются в нескольких хуках
local webLinters = new Mapping<String, Step> {
    ["biome"] {
        glob    = List("**/*.ts", "**/*.js", "**/*.svelte", "**/*.css", "**/*.json")
        exclude = List("**/node_modules/**", "**/dist/**", "**/build/**", "**/.svelte-kit/**", "**/generated/**")
        check   = "biome check {{files}}"
        fix     = "biome check --write {{files}}"
    }
}

// Шаги для Rust
local rustLinters = new Mapping<String, Step> {
    ["cargo-fmt"] {
        glob  = List("**/*.rs")
        check = "cargo fmt --all --check"
        fix   = "cargo fmt --all"
    }
    ["cargo-clippy"] {
        glob    = List("**/*.rs", "**/Cargo.toml")
        check   = "cargo clippy -- -D warnings"
        depends = List("cargo-fmt")   // ждёт cargo-fmt перед запуском
    }
}

hooks {
    ["pre-commit"] {
        fix   = true       // запускать fix-команды и стейджить исправленные файлы
        stash = "git"      // прятать unstaged изменения
        steps = new Mapping {
            ...webLinters
            ...rustLinters
        }
    }

    ["commit-msg"] {
        steps {
            ["check-conventional-commit"] = Builtins.check_conventional_commit
        }
    }

    ["pre-push"] {
        steps = new Mapping {
            ...webLinters
            ...rustLinters
        }
    }

    // для ручного запуска: hk fix / hk check
    ["fix"] {
        fix   = true
        steps = new Mapping { ...webLinters ...rustLinters }
    }
    ["check"] {
        steps = new Mapping { ...webLinters ...rustLinters }
    }
}
```

## Как работает pre-commit

1. Ты делаешь `git commit`
2. hk прячет unstaged изменения через `git stash`
3. Берёт только staged файлы подходящие под `glob`
4. Запускает `biome check --write` и `cargo fmt` **параллельно**
5. `cargo-clippy` ждёт `cargo-fmt` через `depends`
6. Если что-то исправилось — автоматически делает `git add`
7. Восстанавливает unstaged изменения
8. Коммит проходит

Если линтер нашёл ошибки которые не может исправить автоматически — коммит блокируется.

## Как работает commit-msg

Проверяет формат сообщения коммита по [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: добавить авторизацию         ✓
fix(api): исправить таймаут         ✓
chore: обновить зависимости         ✓
просто какой-то текст               ✗
```

## Как работает ...spread

```pkl
local webLinters = new Mapping<String, Step> { ... }
local rustLinters = new Mapping<String, Step> { ... }

steps = new Mapping {
    ...webLinters    // вставляет все шаги из webLinters
    ...rustLinters   // и все из rustLinters
}
```

Шаги описаны один раз и переиспользуются во всех хуках без дублирования.

## Проверить что настроено правильно

```bash
hk run pre-commit --plan
```

Покажет что будет запущено и на каких файлах — без реального выполнения.
