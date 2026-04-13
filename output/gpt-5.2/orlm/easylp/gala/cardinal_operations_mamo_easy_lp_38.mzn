% Investment allocation (integer linear optimization)
% All data embedded as requested.

int: BUDGET = 100000;

int: MIN_X = 10000;
int: MIN_Y = 5000;

int: RISK_A = 3;          % coefficient on X
int: RISK_B = 1;          % coefficient on Y (subtracted)
int: RISK_MIN = 20000;    % required: 3*X - Y >= 20000

int: COST_X = 5000;       % cost per dollar in X
int: COST_Y = 4000;       % cost per dollar in Y

% Decision variables (whole dollars)
var MIN_X..BUDGET: x;
var MIN_Y..BUDGET: y;

% Constraints
constraint x + y <= BUDGET;
constraint RISK_A * x - RISK_B * y >= RISK_MIN;

% Objective: minimize total cost
var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

% Rounded to nearest hundred dollars
var int: rounded_cost = 100 * ((total_cost + 50) div 100);

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "rounded_to_nearest_100 = ", show(rounded_cost), "\n"
];