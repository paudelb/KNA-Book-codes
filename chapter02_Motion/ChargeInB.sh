#!/bin/bash

om=6.26         # omega
v0=(1 20)       # v0 theta (degrees)
ts=(10 0.01)    # tf dt


gfortran ChargeInB.f90 -o chg
./chg <<EOF
$om         omega
${v0[@]}    v0 theta (in degrees)
${ts[@]}    tf dt
EOF
