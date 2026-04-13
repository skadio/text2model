% Parameters (with values embedded)
int: N = 5;
set of int: CHILDREN = 1..N;

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
var int: total_cost;

% Constraints
constraint total_cost = sum(i in CHILDREN)(cost[i] * take[i]);

% Up to 3 children, at least 2 children
constraint sum(i in CHILDREN)(take[i]) <= max_children;
constraint sum(i in CHILDREN)(take[i]) >= min_children;

% Bob is definitely taken
constraint take[Bob] = 1;

% If take Alice, do not take Diana
constraint take[Alice] + take[Diana] <= 1;

% If take Bob, do not take Charlie
constraint take[Bob] + take[Charlie] <= 1;

% If take Charlie, must also take Diana
constraint take[Charlie] <= take[Diana];

% If take Diana, must also take Ella
constraint take[Diana] <= take[Ella];

% Objective
solve minimize total_cost;