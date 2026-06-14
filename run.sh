#!/usr/bin/env bash
set -e
CMD="$1"
case "$CMD" in
  build_generator)
    docker build -t tp-generator ./generator
    ;;

  run_generator)
    mkdir -p data
    docker run --rm -v "$(pwd)/data:/data" tp-generator
    ;;

  create_local_data)
    mkdir -p local_data
    python3 generator/generate.py local_data
    ;;

  build_reporter)
    docker build -t tp-reporter ./reporter
    ;;

  run_reporter)
    mkdir -p data
    docker run --rm -v "$(pwd)/data:/data" tp-reporter
    ;;

  structure)
    find .
    ;;

  clear_data)
    rm -f data/*.csv data/*.html || true
    ;;

  inside_generator)
    mkdir -p data
    docker run --rm -it -v "$(pwd)/data:/data" tp-generator sh -c "ls -R /data"
    ;;

  inside_reporter)
    mkdir -p data
    docker run --rm -it -v "$(pwd)/data:/data" tp-reporter sh -c "ls -R /data"
    ;;
  report_server)
    mkdir -p data
    # предполагаем, что report.html уже создан run_reporter
    docker build -t tp-report-server ./report_server
    docker run --rm -d -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html" tp-report-server
    ;;
  *)
    echo "Usage: $0 {build_generator|run_generator|create_local_data|build_reporter|run_reporter|structure|clear_data|inside_generator|inside_reporter}"
    exit 1
    ;;
esac