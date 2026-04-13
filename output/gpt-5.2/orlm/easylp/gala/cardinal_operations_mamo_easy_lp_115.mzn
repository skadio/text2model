include "globals.mzn";

% Data (embedded from the problem description)
int: budget_max = 100;
int: eff_min = 150;

int: effX = 2;          % effectiveness points per $ in campaign X
int: effY = 3;          % effectiveness points per $ in campaign Y

int: costX = 20;        % $ cost per effectiveness unit in X
int: costY = 30;        % $ cost per effectiveness unit in Y

% Decision variables: dollars allocated (whole dollars)
var 0..budget_max: x;   % budget for campaign X
var 0..budget_max: y;   % budget for campaign Y

% Constraints
constraint x + y <= budget_max;
constraint effX * x + effY * y >= eff_min;

% Objective: minimize total cost
% Each dollar in X buys effX units, each unit costs costX => total cost = x*effX*costX
% Similarly for Y.
var int: total_cost = x * effX * costX + y * effY * costY;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];