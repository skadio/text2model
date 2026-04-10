% Parameters (with values embedded)
int: n = 3;
set of int: CH = 1..n;

% Channels: 1=X, 2=Y, 3=Z
array[CH] of int: min_budget = [200, 150, 100];
int: total_budget_max = 1000;

array[CH] of int: cost_per_unit = [50, 60, 70];

% Variables
array[CH] of var 0..total_budget_max: budget;      % integer dollars allocated
var 0..(total_budget_max * max(cost_per_unit)): total_cost;

% Constraints
constraint forall(c in CH) (
  budget[c] >= min_budget[c]
);

constraint sum(c in CH)(budget[c]) <= total_budget_max;

constraint total_cost = sum(c in CH)(cost_per_unit[c] * budget[c]);

% Objective
solve minimize total_cost;