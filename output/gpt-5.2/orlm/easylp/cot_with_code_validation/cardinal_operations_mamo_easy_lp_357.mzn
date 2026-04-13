% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [250, 250, 150, 150];

% Costs in cents to keep integrality (1.5 -> 150 cents, etc.)
array[P] of int: cost_cents = [150, 200, 300, 400];

% Variables
array[P] of var int: x;
var int: total_cost_cents;

% Constraints
constraint forall(i in P) (x[i] >= lb[i]);
constraint forall(i in P) (x[i] <= ub[i]);

constraint x[1] + x[2] <= 500;
constraint x[3] + x[4] <= 300;

constraint x[1] + x[3] >= 200;
constraint x[2] + x[4] >= 100;

constraint total_cost_cents = sum(i in P)(cost_cents[i] * x[i]);

% Objective
solve minimize total_cost_cents;