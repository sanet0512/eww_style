#!/bin/bash
top -bn1 | grep "Cpu(s)" | awk "{print int(\$2)}"
