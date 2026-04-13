% Parameters
int: N = 4;
set of int: P = 1..N;

array[P] of int: income = [12500, 35000, 23000, 100000];
array[P] of int: cost   = [1500000, 2100000, 2300000, 4200000];

int: budget = 7000000;

% Variables
array[P] of var 0..1: buy;
var 0..sum(income): total_income;
var 0..sum(cost): total_cost;

% Constraints
constraint total_income = sum(p in P)(income[p] * buy[p]);
constraint total_cost   = sum(p in P)(cost[p] * buy[p]);

constraint total_cost <= budget;

% If purchase Property 4, cannot purchase Property 3
constraint buy[4] + buy[3] <= 1;

% Objective
solve maximize total_income;