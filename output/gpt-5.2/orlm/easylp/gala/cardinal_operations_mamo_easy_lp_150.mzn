% Shipping cost minimization with integer units of cargo X and Y

% Data (embedded as requested)
int: capacity = 30;          % tons
int: wx = 2;                 % tons per unit of X
int: wy = 3;                 % tons per unit of Y
int: contract_min = 10;      % tons
int: cx = 5;                 % $ per unit of X
int: cy = 7;                 % $ per unit of Y

% Decision variables: integer number of units
var 0..capacity div wx: x;   % units of X
var 0..capacity div wy: y;   % units of Y

% Capacity constraint
constraint wx * x + wy * y <= capacity;

% Contract requirement: weight of 4 units of X and 1 unit of Y at least 10 tons
constraint 4 * wx * x + 1 * wy * y >= contract_min;

% Objective: minimize transportation cost
var int: total_cost = cx * x + cy * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];