#!/bin/bash
free -m | awk "/^Mem:/ {print int(\$3/\$2 * 100)}"
