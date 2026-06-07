# Работа с секретами

## Добавить секрет

```bash
fnox set DATABASE_URL
```

fnox спросит значение интерактивно (чтобы оно не попало в историю терминала), зашифрует и запишет в `fnox.toml`.

Или сразу с указанием провайдера:

```bash
fnox set DATABASE_URL --provider backend
```

## Получить значение

```bash
fnox get DATABASE_URL
# postgres://user:password@localhost:5432/mydb
```

## Список всех секретов

```bash
fnox list
```

```
NAME           PROVIDER   DESCRIPTION
DATABASE_URL   backend    -
JWT_SECRET     backend    -
VITE_API_URL   frontend   -
```

## Запустить команду с секретами как переменными окружения

```bash
fnox exec -- bun run dev
```

Все секреты подставятся как переменные окружения только на время выполнения команды.

## Удалить секрет

```bash
fnox remove DATABASE_URL
```

## Как секрет выглядит в fnox.toml

После добавления в `fnox.toml` появится зашифрованная строка:

```toml
[secrets]
DATABASE_URL = { provider = "backend", value = "YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+...", description = "Main database" }
```

`value` — это зашифрованное значение в формате age. Без приватного ключа это просто набор символов.

## Автоматическая подстановка при запуске shell

Если активировать fnox в shell — секреты будут доступны автоматически в каждой сессии терминала внутри проекта:

```bash
fnox activate
# выполни инструкцию которую выдаст команда
```

После этого просто `echo $DATABASE_URL` сработает без `fnox exec`.
