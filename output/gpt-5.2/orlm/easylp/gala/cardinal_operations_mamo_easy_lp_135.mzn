% Environmental investment optimization (all data embedded)

% Decision variables (whole-number investments)
var 0..20: x;   % Project X investment units
var 0..20: y;   % Project Y investment units

% Constraints
constraint x + y <= 20;           % budget limit in investment units
constraint 2 * x + y >= 10;       % minimum environmental impact

% Cost parameters
int: costX = 4;
int: costY = 5;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];