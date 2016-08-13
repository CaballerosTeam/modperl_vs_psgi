#!/usr/bin/env bash

SCRIPT="$(readlink -f ${BASH_SOURCE[0]})"
DIR="$(dirname ${SCRIPT})"
AB_PL=${DIR}/../assets/ab.pl

perl ${AB_PL} -u mod_perl.example.com/ -n 3
