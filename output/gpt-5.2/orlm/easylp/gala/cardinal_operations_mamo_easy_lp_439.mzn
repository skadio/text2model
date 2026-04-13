include "globals.mzn";

/*** Data (embedded from problem statement) ***/
int: costDoctor = 5;
int: costNurse  = 3;

int: minDemand = 50;     % 2*D + N >= 50
int: maxService = 100;   % D + 3*N <= 100
int: minDiff = 10;       % D >= N + 10

/*** Decision variables (whole-number staffing) ***/
var 0..1000: D;   % Doctors
var 0..1000: N;   % Nurses

/*** Constraints ***/
constraint 2*D + N >= minDemand;
constraint D + 3*N <= maxService;
constraint D >= N + minDiff;

/*** Objective: minimize total staffing cost ***/
var 0..1000000: totalCost = costDoctor*D + costNurse*N;

solve minimize totalCost;

/*** Output ***/
output [
  "Doctors = ", show(D), "\n",
  "Nurses = ", show(N), "\n",
  "TotalCost = ", show(totalCost), "\n"
];