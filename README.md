# Simple C project

Template for simple C project setup on Linux.

# Project Setup

## Prerequisites

Install the following tools:
- make
- gcc / clang

## Clone this repository

```shell
$ git clone https://github.com/stanislavsabev/proj_setup_python.git <your-project-name>
$ cd  <your-project-name>
```

(Optionally) re-init the .git folder:

```shell
$ git init

```

## Development

Use the `Makefile`

Help
```shell
$ make help
Usage:
  make <target>

Targets:
  help        Show this message
  makedir     Create build directories
  build       Build Release
  build_debug  Build Debug
  debug       Run Debug
  run         Run Release
  clean       Clean build directories
```


Build

```shell
$ make build
gcc -Wall -Wextra -std=c17 -c -o obj/main.o src/main.c
gcc -Wall -Wextra -std=c17 -o bin/main obj/main.o
build: OK

$ make build_debug
gcc -Wall -Wextra -std=c17 -c -g -o obj/debug/main.o src/main.c
gcc -Wall -Wextra -std=c17 -g obj/debug/main.o -o bin/debug/main
build debug: OK
```


Run

```shell
$ make run
build: OK
run: ./bin/main
Hello world!

$ make debug
build debug: OK
debug: ./bin/debug/main
Hello world!
```

Clean up

```shell
$ make clean
Clean bin obj
```