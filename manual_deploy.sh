#!/bin/sh

OLD_CONTAINER=`sudo docker ps -q --filter="ancestor=mydockertestacc/main | head -n 1"`
