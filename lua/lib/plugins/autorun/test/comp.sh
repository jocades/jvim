#!/bin/bash

gcc "$1" -o "$2"

if [ $? -eq 0 ]; then
    echo "Compilation successful"
else
    echo "Compilation failed"
fi
