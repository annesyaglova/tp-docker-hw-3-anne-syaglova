# tp-docker-hw-3-anne-syaglova
Проект состоит из двух основных сущностей:
- **generator** — Python‑скрипт, который генерирует CSV‑файл с данными.
- **reporter** — Node.js‑скрипт, который читает CSV и формирует HTML‑отчёт
Все действия выполняются через скрипт `run.sh`.
## Требования
Работа тестировалась в GitHub Codespaces (Linux, Docker, Python, Node.js уже предустановлены)
## Основные команды run.sh
### Генератор данных
```bash
./run.sh build_generator      # сборка Docker-образа генератора
./run.sh run_generator        # запуск генератора, создаёт data/data.csv на хосте
./run.sh create_local_data    # локальный запуск генератора, создаёт local_data/data.csv
```
Генератор использует файл `generator/generate.py` и образ `python:3.12-slim`
### Аналитик данных (reporter)
```bash
./run.sh build_reporter       # сборка Docker-образа аналитика
./run.sh run_reporter         # запуск аналитика, создаёт data/report.html на хосте
```
Reporter использует образ `node:20-alpine` и библиотеку [`csv-parse`](https://www.npmjs.com/package/csv-parse) для чтения CSV.
### Вспомогательные команды
```bash
./run.sh structure            # выводит структуру проекта (аналог tree)
./run.sh clear_data           # удаляет все .csv и .html из папки data/
./run.sh inside_generator     # показывает содержимое /data внутри контейнера генератора
./run.sh inside_reporter      # показывает содержимое /data внутри контейнера репортёра
```
После `clear_data` повторный запуск `run_generator` и `run_reporter` полностью пересобирает данные и отчёт
## Запуск веб-сервера с отчётом (report_server)
HTML‑отчёт (`data/report.html`) можно открыть в браузере через третий контейнер с nginx
```bash
./run.sh report_server
```
Команда:
- собирает образ `tp-report-server` на базе `nginx:alpine`,
- запускает контейнер с монтированием `./data` в `/usr/share/nginx/html`,
- пробрасывает порт `8080` хоста Codespaces в порт `80` контейнера.
### Как открыть отчёт в Codespaces
1. Запустить генератор и репортёр:
   ```bash
   ./run.sh clear_data
   ./run.sh build_generator
   ./run.sh run_generator
   ./run.sh build_reporter
   ./run.sh run_reporter
   ```
   После этого в `data/` должны быть `data.csv` и `report.html`.
2. Запустить веб-сервер:
   ```bash
   ./run.sh report_server
   ```
3. Открыть вкладку **PORTS** в Codespaces.
4. Найти порт `8080`. Если порта нет — добавить через **Add Port** → `8080`.
5. Нажать на ссылку `Open in Browser` для порта `8080`.
В браузере откроется HTML‑отчёт (`data/index.html` / `data/report.html`), который раздаётся nginx из смонтированной папки `data/`.
Если по адресу `/` возвращается 403, отчёт можно открыть по URL вида:
- `http://<адрес_из_Codespaces>:8080/report.html`
