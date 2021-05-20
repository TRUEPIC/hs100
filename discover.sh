#!/bin/bash

nmap -p 9999 10.1.100.0/24 -oG - | grep open
