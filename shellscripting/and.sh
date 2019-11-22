#! /bin/bash

age=25

if [ "$age" -gt 18 -a "$age" -lt 30 ]
then 
echo "valid age"
else 
echo "invalid age"
fi