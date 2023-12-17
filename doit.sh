#!/bin/bash
yr=2023
num=05
cmd=python
ext=py
ln -sf   $yr/$num/${yr}${num}.$ext current.py

cd $yr/$num
$cmd ${yr}${num}.$ext
