#!/bin/bash
free -m | awk 'NR==2{printf "%.0f", $3*100/$2}' 