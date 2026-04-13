include "globals.mzn";

% Data (embedded as requested)
int: B_max = 200;          % total budget cap
int: X_max = 150;          % project X cap
int: Y_max = 100;          % project Y cap
int: diff_max = 50;        % X - Y <= 50

float: wX = 0.6;
float: wY = 0.8;
float: impact_min = 120.0;

int: costX = 50;
int: costY = 80;

% Decision variables (whole-number allocations)
var 0..X_max: X;
var 0..Y_max: Y;

% Constraints
constraint X + Y <= B_max;
constraint wX * int2float(X) + wY * int2float(Y) >= impact_min;
constraint X - Y <= diff_max;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];