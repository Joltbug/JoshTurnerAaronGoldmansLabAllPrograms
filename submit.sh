!#/bin/bash

for elem in "$@";do
	echo  "qsub $elem"/parse.pbs
done
