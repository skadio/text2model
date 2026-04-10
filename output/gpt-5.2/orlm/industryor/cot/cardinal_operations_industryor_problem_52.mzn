% Parameters (with values embedded)
int: N = 6;
set of int: CHILDREN = 1..N;

int: Harry = 1;
int: Hermione = 2;
int: Ron = 3;
int: Fred = 4;
int: George = 5;
int: Ginny = 6;

array[CHILDREN] of int: cost = [1200, 1650, 750, 800, 800, 1500];

int: max_children = 4;
int: min_children = 3;

% Variables
array[CHILDREN] of var 0..1: take;
var int: total_cost;

% Constraints
constraint take[Ginny] = 1;

constraint sum(c in CHILDREN)(take[c]) <= max_children;
constraint sum(c in CHILDREN)(take[c]) >= min_children;

constraint take[Harry] + take[Fred] <= 1;
constraint take[Harry] + take[George] <= 1;

constraint take[George] <= take[Fred];
constraint take[George] <= take[Hermione];

constraint total_cost = sum(c in CHILDREN)(cost[c] * take[c]);

% Objective
solve minimize total_cost;