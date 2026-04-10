include "globals.mzn";

% Data (embedded)
int: minVitA = 150;
int: minVitD = 300;
int: maxVitE = 400;

array[1..2] of int: vitA = [8, 15];   % per cup: drink A, drink B
array[1..2] of int: vitD = [6, 2];
array[1..2] of int: vitE = [10, 20];
array[1..2] of int: vitK = [4, 12];

% Decision variables: number of cups of each drink (A then B)
% Upper bounds chosen safely from constraints (not too loose, not too tight)
var 0..50: cupsA;
var 0..50: cupsB;

% Nutrient totals
var 0..10000: totalA = vitA[1]*cupsA + vitA[2]*cupsB;
var 0..10000: totalD = vitD[1]*cupsA + vitD[2]*cupsB;
var 0..10000: totalE = vitE[1]*cupsA + vitE[2]*cupsB;
var 0..10000: totalK = vitK[1]*cupsA + vitK[2]*cupsB;

% Constraints
constraint totalA >= minVitA;
constraint totalD >= minVitD;
constraint totalE <= maxVitE;

% Objective: minimize Vitamin K
solve minimize totalK;

output [
  "cupsA = ", show(cupsA), "\n",
  "cupsB = ", show(cupsB), "\n",
  "Total Vitamin A = ", show(totalA), "\n",
  "Total Vitamin D = ", show(totalD), "\n",
  "Total Vitamin E = ", show(totalE), "\n",
  "Total Vitamin K = ", show(totalK), "\n"
];