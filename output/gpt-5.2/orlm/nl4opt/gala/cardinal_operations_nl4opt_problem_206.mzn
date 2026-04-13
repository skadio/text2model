% Diet / supplement cost minimization (integer servings)
include "globals.mzn";

% Data (embedded as required)
int: caA = 30;
int: mgA = 50;
int: costA = 14;

int: caB = 60;
int: mgB = 10;
int: costB = 25;

int: reqCa = 400;
int: reqMg = 50;

% Decision variables: number of servings per day (nonnegative integers)
% Safe upper bounds:
% For Calcium: max needed if only A -> ceil(400/30)=14; only B -> ceil(400/60)=7
% Add a little slack to be safe.
var 0..30: xA;
var 0..30: xB;

% Nutrient constraints
constraint caA * xA + caB * xB >= reqCa;
constraint mgA * xA + mgB * xB >= reqMg;

% Objective: minimize daily cost
var int: totalCost = costA * xA + costB * xB;

solve minimize totalCost;

output [
  "Servings A = ", show(xA), "\n",
  "Servings B = ", show(xB), "\n",
  "Total cost = $", show(totalCost), "\n",
  "Calcium = ", show(caA*xA + caB*xB), " g\n",
  "Magnesium = ", show(mgA*xA + mgB*xB), " g\n"
];