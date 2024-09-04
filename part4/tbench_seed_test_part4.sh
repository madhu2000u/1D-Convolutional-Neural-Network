#!/bin/sh
rm seed_output_part2.txt;
for i in {567..570}
do
    echo "Starting seed - " $i;
    vsim -sv_seed $i tbench3 -c -do "run -all" >> seed_output_part4.txt;
    echo "Seed done - " $i;
done
