# Профили и продвинутые сценарии

## Профили

Профили позволяют включать или выключать отдельные шаги в зависимости от контекста. По умолчанию шаги без профиля всегда запускаются.

```pkl
["typecheck"] {
    glob     = List("**/*.ts", "**/*.svelte")
    check    = "bun tsc --noEmit"
    profiles = List("slow")   // запускается только при --slow
}
```

Запустить с профилем:

```bash
hk run pre-commit --profile slow
# или короче:
hk run pre-commit --slow
```

### Зачем это нужно

Некоторые проверки быстрые (Biome — миллисекунды), другие медленные (TypeScript — несколько секунд). Медленные шаги удобно вынести в профиль `slow` и запускать только перед пушем или в CI — не тормозя каждый коммит.

```pkl
["biome"] {
    glob  = List("**/*.ts", "**/*.svelte")
    fix   = "biome check --write {{files}}"
    // без profiles — запускается всегда
}

["typecheck"] {
    glob     = List("**/*.ts")
    check    = "bun tsc --noEmit"
    profiles = List("slow")
    // только при --slow
}
```

## Зависимости между шагами

Если один шаг должен выполниться раньше другого — используй `depends`:

```pkl
["biome"] {
    glob = List("**/*.ts")
    fix  = "biome check --write {{files}}"
}

["typecheck"] {
    glob    = List("**/*.ts")
    check   = "bun tsc --noEmit"
    depends = List("biome")   // сначала Biome форматирует, потом tsc проверяет
}
```

Без `depends` шаги идут параллельно — это быстрее, но порядок не гарантирован.

## Переменные окружения для шагов

```pkl
["biome"] {
    glob = List("**/*.ts")
    fix  = "biome check --write {{files}}"
    env {
        ["NODE_ENV"] = "production"
    }
}
```

## Исключения

Глобально для всего конфига:

```pkl
exclude = List("**/generated/**", "**/dist/**")
```

Или только для конкретного шага:

```pkl
["biome"] {
    glob    = List("**/*.ts")
    exclude = List("**/node_modules/**", "**/*.test.ts")
    fix     = "biome check --write {{files}}"
}
```

## CI-режим

В CI нужно только проверять, не исправлять:

```bash
# через команду
hk check --all

# через переменную окружения
HK_FIX=0 hk run pre-commit
```

## Параллельность

По умолчанию hk запускает столько параллельных задач сколько есть ядер. Можно ограничить:

```pkl
jobs = 4
```

Или через флаг:

```bash
hk check --jobs 2
```
