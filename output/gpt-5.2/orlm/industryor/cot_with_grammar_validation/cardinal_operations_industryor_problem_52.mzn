% Parameters
int: n = 6;
set of int: CHILD = 1..n;

int: HARRY = 1;
int: HERMIONE = 2;
int: RON = 3;
int: FRED = 4;
int: GEORGE = 5;
int: GINNY = 6;

array[CHILD] of int: cost = [1200, 1650, 750, 800, 800, 1500];

int: max_take = 4;
int: min_take = 3;

% Variables
array[CHILD] of var 0..1: take;
var 0..sum(i in CHILD)(cost[i]): total_cost;

% Constraints
constraint total_cost = sum(i in CHILD)(cost[i] * take[i]);

constraint take[GINNY] = 1;

constraint sum(i in CHILD)(take[i]) <= max_take;
constraint sum(i in CHILD)(take[i]) >= min_take;

constraint take[HARRY] + take[FRED] <= 1;
constraint take[HARRY] + take[GEORGE] <= 1;

constraint take[GEORGE] <= take[FRED];
constraint take[GEORGE] <= take[HERMIONE];

% Objective
solve minimize total_cost;