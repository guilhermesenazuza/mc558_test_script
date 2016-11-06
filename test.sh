#!/bin/bash
cd ..
g++ main.cpp -ansi -pedantic -Wall -lm -o main

for i in $(seq 1 $2)
do
    temp=$i
    printf -v temp "%02d" $temp >/dev/null 2>&1
    if ! test -f arq$i.in
    then
        
        curl "https://susy.ic.unicamp.br:9999/mc558ab/0$1/dados/arq$temp.in" --insecure > arq$i.in
    fi
    
    if ! test -f arq$i.res
    then
        curl "https://susy.ic.unicamp.br:9999/mc558ab/0$1/dados/arq$temp.res" --insecure > arq$i.res
    fi
done


n=$(find . -maxdepth 1 -name "arq0*.in" | wc -l)

for i in $(seq 1 $2)
do
    echo "Test $i";
    ./main < "arq$i.in" > "arq$i.out";
    
    if cmp "arq$i.res" "arq$i.out" >/dev/null 2>&1
    then
        echo "Resultado Correto";
    else
        echo "Resultado Incorreto";
        diff "arq$i.res" "arq$i.out"
    fi
    echo
    echo "=======================";
done

