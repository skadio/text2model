% Parameters
int: N = 4;
set of int: R = 1..N;

array[R] of int: revenue = [15000, 40000, 30000, 50000];
array[R] of int: cost    = [1600000, 2500000, 1800000, 3000000];

int: budget = 6000000;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;

% Variables
array[R] of var 0..1: buy;
var 0..sum(revenue): total_revenue;

% Constraints
constraint total_revenue = sum(r in R)(revenue[r] * buy[r]);
constraint sum(r in R)(cost[r] * buy[r]) <= budget;

% If they purchase Restaurant D, then they cannot purchase Restaurant A
constraint buy[D] + buy[A] <= 1;

% Objective
solve maximize total_revenue;