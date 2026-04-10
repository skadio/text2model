% Steel furnace method allocation (LP formulated as an integer/linear MiniZinc model)
% Data embedded as required.

int: F = 2;          % number of furnaces
int: a = 2;          % hours per furnace for method 1
int: b = 3;          % hours per furnace for method 2
int: m = 50;         % fuel cost for method 1
int: n = 70;         % fuel cost for method 2
int: k = 10;         % tons produced per furnace (regardless of method)
int: d = 30;         % minimum tons required
int: c = 12;         % total hours available across both furnaces

% Decision variables:
% x = number of furnaces allocated to method 1
% y = number of furnaces allocated to method 2
var 0..F: x;
var 0..F: y;

% Constraints
constraint x + y = F;                         % allocate both furnaces
constraint a*x + b*y <= c;                    % total time within limit
constraint k*(x + y) >= d;                    % production requirement

% Objective: minimize total fuel expenses
var int: total_cost = m*x + n*y;

solve minimize total_cost;

output [
  "x (furnaces using method 1) = ", show(x), "\n",
  "y (furnaces using method 2) = ", show(y), "\n",
  "Total hours used = ", show(a*x + b*y), " (<= ", show(c), ")\n",
  "Total tons produced = ", show(k*(x+y)), " (>= ", show(d), ")\n",
  "Total fuel cost = ", show(total_cost), "\n"
];