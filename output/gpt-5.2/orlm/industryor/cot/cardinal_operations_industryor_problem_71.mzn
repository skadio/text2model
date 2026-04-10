% Parameters (with values embedded)
int: N = 4;
set of int: PROPS = 1..N;

array[PROPS] of int: income = [12500, 35000, 23000, 100000];
array[PROPS] of int: cost   = [1500000, 2100000, 2300000, 4200000];
int: budget = 7000000;

% Variables
array[PROPS] of var 0..1: buy;
var 0..sum(income): total_income;

% Constraints
constraint total_income = sum(p in PROPS)(income[p] * buy[p]);
constraint sum(p in PROPS)(cost[p] * buy[p]) <= budget;

% If they purchase Property 4, they cannot purchase Property 3
constraint buy[4] + buy[3] <= 1;

% Objective
solve maximize total_income;