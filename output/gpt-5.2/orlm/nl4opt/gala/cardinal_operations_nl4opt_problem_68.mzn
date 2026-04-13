include "globals.mzn";

/* Data (embedded from problem statement) */
int: a1 = 20;   % allergy pills per hour in factory 1
int: f1 = 15;   % fever pills per hour in factory 1
int: a2 = 10;   % allergy pills per hour in factory 2
int: f2 = 30;   % fever pills per hour in factory 2

int: c1 = 20;   % rare compound units per hour in factory 1
int: c2 = 30;   % rare compound units per hour in factory 2
int: Cmax = 1000;

int: Amin = 700;
int: Fmin = 600;

/* Decision variables: hours to run each factory (assume integer hours) */
var 0..Cmax div c1: h1;
var 0..Cmax div c2: h2;

/* Constraints */
constraint a1*h1 + a2*h2 >= Amin;
constraint f1*h1 + f2*h2 >= Fmin;
constraint c1*h1 + c2*h2 <= Cmax;

/* Objective: minimize total time (sum of hours run) */
var 0..(Cmax div c1 + Cmax div c2): total_time = h1 + h2;
solve minimize total_time;

output [
  "Factory1_hours = ", show(h1), "\n",
  "Factory2_hours = ", show(h2), "\n",
  "Total_time = ", show(total_time), "\n",
  "Allergy_produced = ", show(a1*h1 + a2*h2), "\n",
  "Fever_produced = ", show(f1*h1 + f2*h2), "\n",
  "Compound_used = ", show(c1*h1 + c2*h2), "\n"
];