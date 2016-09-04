#!/usr/bin/env bash

SCRIPT="$(readlink -f ${BASH_SOURCE[0]})"
DIR="$(dirname ${SCRIPT})"
AB_PL=${DIR}/../assets/ab.pl

perl ${AB_PL} -r 100000 -u psgi.example.com:8000/ -n 3 -m '(uwsgi|nginx)'
