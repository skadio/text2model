% Energy investment allocation problem (all data embedded)

int: BUDGET = 5000;

% Decision variables (integer investments)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2000 - 3 * Y;   % "minimum investment of 2000 units more than negative three times Y"
constraint Z >= Y + 1000;       % Z at least 1000 more than Y

% Objective: minimize total cost
var int: total_cost = 20 * X + 15 * Y + 30 * Z;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];