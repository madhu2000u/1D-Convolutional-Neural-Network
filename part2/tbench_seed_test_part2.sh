#!/bin/sh
rm seed_output_part2.txt;
for i in {734..737}
do
    echo "Starting seed - " $i;
    vsim -sv_seed $i tbench2 -c -do "run -all" >> seed_output_part2.txt;
    echo "Seed done - " $i;
done
