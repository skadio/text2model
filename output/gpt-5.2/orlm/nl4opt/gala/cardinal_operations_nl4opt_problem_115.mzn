% Teddy bear production LP (integer hours) in MiniZinc
% Data is embedded as requested.

include "globals.mzn";

% Parameters (from problem statement)
int: cost1 = 300;
int: cost2 = 600;

int: b1 = 5;   int: w1 = 6;  int: br1 = 3;   % factory 1 output per hour
int: b2 = 10;  int: w2 = 10; int: br2 = 0;   % factory 2 output per hour

int: reqB = 20;
int: reqW = 5;
int: reqBr = 15;

% Decision variables: hours to run each factory per day
% (Hours taken as nonnegative integers; upper bounds chosen safely.)
var 0..100: h1;
var 0..100: h2;

% Demand constraints (at least required production)
constraint b1*h1 + b2*h2 >= reqB;
constraint w1*h1 + w2*h2 >= reqW;
constraint br1*h1 + br2*h2 >= reqBr;

% Objective: minimize total cost
var int: totalCost = cost1*h1 + cost2*h2;

solve minimize totalCost;

output [
  "h1 = ", show(h1), " hours\n",
  "h2 = ", show(h2), " hours\n",
  "Total cost = $", show(totalCost), "\n",
  "Produced black  = ", show(b1*h1 + b2*h2), "\n",
  "Produced white  = ", show(w1*h1 + w2*h2), "\n",
  "Produced brown  = ", show(br1*h1 + br2*h2), "\n"
];