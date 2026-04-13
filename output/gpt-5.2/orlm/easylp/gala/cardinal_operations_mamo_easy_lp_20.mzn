% Manufacturing cost minimization with integer production quantities

int: costX = 50;
int: costY = 10;

% Resource and demand constraints
int: resourceMax = 200;   % 2*X + Y <= 200
int: demandMin  = 50;    % 4*X + Y >= 50

% Decision variables (whole numbers)
var 0..resourceMax: X;    % units of product X
var 0..resourceMax: Y;    % units of product Y

% Constraints
constraint 2 * X + Y <= resourceMax;
constraint 4 * X + Y >= demandMin;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(totalCost), "\n"
];