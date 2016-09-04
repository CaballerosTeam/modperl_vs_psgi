#!/usr/bin/env bash

SCRIPT="$(readlink -f ${BASH_SOURCE[0]})"
DIR="$(dirname ${SCRIPT})"
AB_PL=${DIR}/../assets/ab.pl

perl ${AB_PL} -r 100000 -u mod_perl.example.com/ -n 3 -m httpd
