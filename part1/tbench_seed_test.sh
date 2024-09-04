#!/bin/sh
rm seed_output.txt;
for i in {438..440}
do
    echo "Starting seed - " $i;
    vsim -sv_seed $i tbench1 -c -do "run -all" >> seed_output.txt;
    echo "Seed done - " $i;
done
