% Parameters
int: N = 6;
set of int: CHILDREN = 1..N;

int: HARRY = 1;
int: HERMIONE = 2;
int: RON = 3;
int: FRED = 4;
int: GEORGE = 5;
int: GINNY = 6;

array[CHILDREN] of int: cost = [1200, 1650, 750, 800, 800, 1500];

int: MAX_TAKE = 4;
int: MIN_TAKE = 3;

% Variables
array[CHILDREN] of var 0..1: take;
var int: total_cost;

% Constraints
constraint total_cost = sum(i in CHILDREN)(cost[i] * take[i]);

constraint sum(i in CHILDREN)(take[i]) <= MAX_TAKE;
constraint sum(i in CHILDREN)(take[i]) >= MIN_TAKE;

constraint take[GINNY] = 1;

constraint take[HARRY] + take[FRED] <= 1;
constraint take[HARRY] + take[GEORGE] <= 1;

constraint take[GEORGE] <= take[FRED];
constraint take[GEORGE] <= take[HERMIONE];

% Objective
solve minimize total_cost;