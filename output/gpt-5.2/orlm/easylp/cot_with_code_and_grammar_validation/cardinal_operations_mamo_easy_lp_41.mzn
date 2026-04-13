% Parameters
int: BUDGET = 10000;
int: MIN_X = 2000;
int: MIN_Y = 3000;

% Costs given in dollars per unit; use cents to keep integrality
int: COST_X_CENTS = 2;  % $0.02
int: COST_Y_CENTS = 3;  % $0.03

% Variables
var MIN_X..BUDGET: x;
var MIN_Y..BUDGET: y;
var 0..(COST_X_CENTS * BUDGET + COST_Y_CENTS * BUDGET): total_cost_cents;

% Constraints
constraint x + y <= BUDGET;

constraint total_cost_cents = COST_X_CENTS * x + COST_Y_CENTS * y;

% Objective
solve minimize total_cost_cents;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost_cents = ", show(total_cost_cents), "\n",
  "total_cost_dollars_rounded = ", show( (total_cost_cents + 50) div 100 ), "\n"
];