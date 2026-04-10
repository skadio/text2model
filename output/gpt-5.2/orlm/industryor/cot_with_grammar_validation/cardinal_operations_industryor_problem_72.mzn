% Parameters
set of int: CHILDREN = 1..5;
int: Alice = 1;
int: Bob = 2;
int: Charlie = 3;
int: Diana = 4;
int: Ella = 5;

array[CHILDREN] of int: cost = [1000, 900, 600, 500, 700];
int: max_children = 3;
int: min_children = 2;

% Variables
array[CHILDREN] of var 0..1: take;
var 0..sum(i in CHILDREN)(cost[i]): total_cost;

% Constraints
constraint total_cost = sum(i in CHILDREN)(cost[i] * take[i]);

constraint sum(i in CHILDREN)(take[i]) <= max_children;
constraint sum(i in CHILDREN)(take[i]) >= min_children;

constraint take[Bob] = 1;

constraint take[Alice] + take[Diana] <= 1;
constraint take[Bob] + take[Charlie] <= 1;

constraint take[Charlie] <= take[Diana];
constraint take[Diana] <= take[Ella];

% Objective
solve minimize total_cost;