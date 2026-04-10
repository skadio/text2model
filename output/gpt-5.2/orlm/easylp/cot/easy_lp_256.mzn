% Parameters (with values embedded)
int: BUDGET_MAX = 100;
int: DEMAND_MIN = 50;
int: RISK_MAX = 30;

array[1..3] of int: unit_cost = [5, 4, 3]; % costs for x1,x2,x3

array[1..3] of int: x_max = [100, 100, 100]; % per-supplier maximum limits (not otherwise specified)

% Variables
array[1..3] of var 0..100: x; % x[1]=x1, x[2]=x2, x[3]=x3 (integer investments)

% Constraints
constraint forall(i in 1..3)(x[i] <= x_max[i]);

constraint x[1] + x[2] + x[3] <= BUDGET_MAX;

constraint 2*x[1] + 3*x[2] >= DEMAND_MIN;

constraint 4*x[1] - 5*x[3] <= RISK_MAX;

% Objective
var int: total_cost = sum(i in 1..3)(unit_cost[i] * x[i]);
solve minimize total_cost;