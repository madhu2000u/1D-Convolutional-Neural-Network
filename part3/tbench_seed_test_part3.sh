#!/bin/sh
rm seed_output_part3.txt;
for i in {689..691}
do
    echo "Starting seed - " $i;
    vsim -sv_seed $i tbench3 -c -do "run -all" >> seed_output_part3.txt;
    echo "Seed done - " $i;
done
