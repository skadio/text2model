include "globals.mzn";

% Data (embedded as requested)
int: Bmax = 5000;        % total budget limit
int: effMin = 2000;      % minimum effectiveness constraint: 3X - 2Y >= 2000
int: diffMax = 1000;     % |X - Y| <= 1000

int: costX = 1000;       % cost per unit for channel X
int: costY = 1500;       % cost per unit for channel Y

% Decision variables: whole-number allocations (dollars)
var 0..Bmax: x;          % budget for channel X
var 0..Bmax: y;          % budget for channel Y

% Constraints
constraint x + y <= Bmax;
constraint 3 * x - 2 * y >= effMin;
constraint abs(x - y) <= diffMax;

% Objective: minimize total cost
var 0..(costX*Bmax + costY*Bmax): totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];