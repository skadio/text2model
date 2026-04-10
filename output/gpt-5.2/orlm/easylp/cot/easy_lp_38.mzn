% Parameters (with values embedded)
int: budget = 100000;
int: minX = 10000;
int: minY = 5000;
int: risk_req = 20000;          % 3*X - Y >= 20000
int: costX = 5000;              % cost per dollar (as given)
int: costY = 4000;

% Variables
var minX..budget: X;            % whole-number dollars invested in X
var minY..budget: Y;            % whole-number dollars invested in Y

% Constraints
constraint X + Y <= budget;
constraint 3 * X - Y >= risk_req;

% Objective
var 0..(costX*budget + costY*budget): total_cost = costX * X + costY * Y;

solve minimize total_cost;

% Rounded to nearest hundred dollars (integer dollars -> rounding works)
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_cost_rounded_to_nearest_100 = ",
  show( ((total_cost + 50) div 100) * 100 ), "\n"
];