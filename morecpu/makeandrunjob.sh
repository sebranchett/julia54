#!/bin/bash

sed "s/XX/$1/g" time_XX.jl > time_$1.jl
sed "s/XX/$1/g" time_XX.sh > time_$1.sh

sbatch time_$1.sh
