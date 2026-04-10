include "globals.mzn";

% Workload scores per hour
int: wN1 = 3;
int: wN2 = 2;
int: wD1 = 4;
int: wD2 = 5;

% Decision variables: whole hours worked
var 0..100: hN1;
var 0..100: hN2;
var 0..100: hD1;
var 0..100: hD2;

% Constraints
constraint hN1 + hN2 >= 10;
constraint hD1 + hD2 >= 8;

constraint abs(hN1 - hD1) <= 4;
constraint abs(hN2 - hD2) <= 3;

% Objective: minimize total workload score
var 0..10000: totalWorkload = wN1*hN1 + wN2*hN2 + wD1*hD1 + wD2*hD2;

solve minimize totalWorkload;

output [
  "Minimum total workload score = ", show(totalWorkload), "\n",
  "Hours: Nurse1=", show(hN1),
  " Nurse2=", show(hN2),
  " Doctor1=", show(hD1),
  " Doctor2=", show(hD2), "\n"
];