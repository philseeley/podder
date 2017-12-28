#!/bin/bash

tail -c +70 $0 | tar -x -C /usr/local/bin -z -f -
exit

