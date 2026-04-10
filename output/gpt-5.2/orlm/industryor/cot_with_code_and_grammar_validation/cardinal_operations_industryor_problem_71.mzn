% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: income = [12500, 35000, 23000, 100000];
array[P] of int: cost   = [1500000, 2100000, 2300000, 4200000];
int: budget = 7000000;

% Variables
array[P] of var 0..1: buy;
var 0..sum(income): total_income;

% Constraints
constraint sum(p in P)(cost[p] * buy[p]) <= budget;

% If buy Property 4, cannot buy Property 3
constraint buy[4] + buy[3] <= 1;

constraint total_income = sum(p in P)(income[p] * buy[p]);

% Objective
solve maximize total_income;