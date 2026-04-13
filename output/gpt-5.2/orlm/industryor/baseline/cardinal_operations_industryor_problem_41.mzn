% Steel furnaces allocation (LP) as MiniZinc model with embedded data

% Data
int: F = 2;            % number of furnaces
int: a = 2;            % hours per furnace using method 1
int: b = 3;            % hours per furnace using method 2
int: m = 50;           % fuel cost per furnace-hour allocation of method 1
int: n = 70;           % fuel cost per furnace-hour allocation of method 2
int: k = 10;           % tons produced per furnace (regardless of method)
int: d = 30;           % minimum total tons required
int: c = 12;           % total available hours (across both furnaces)

% Decision variables:
% x = number of furnace-uses allocated to method 1 (can be fractional in LP)
% y = number of furnace-uses allocated to method 2 (can be fractional in LP)
var float: x >= 0.0;
var float: y >= 0.0;

% Constraints
constraint x + y <= float(F);                      % at most 2 furnaces total
constraint a*x + b*y <= float(c);                  % total time within 12 hours
constraint k*(x + y) >= float(d);                  % produce at least 30 tons

% Objective: minimize fuel expenses
var float: total_cost = m*x + n*y;
solve minimize total_cost;

output [
  "x (method 1 furnace-uses) = ", show(x), "\n",
  "y (method 2 furnace-uses) = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_hours = ", show(a*x + b*y), "\n",
  "total_tons = ", show(k*(x + y)), "\n"
];