#!/bin/bash
cd $1
java -cp $2/* processing.app.BaseNoGui --board $3 --pref build.path=$4 --pref sketchbook.path=$5 --verify $6