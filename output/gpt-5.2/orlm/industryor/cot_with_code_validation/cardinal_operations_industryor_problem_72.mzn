% Parameters
int: N = 5;
set of int: CHILD = 1..N;

int: Alice = 1;
int: Bob = 2;
int: Charlie = 3;
int: Diana = 4;
int: Ella = 5;

array[CHILD] of int: cost = [1000, 900, 600, 500, 700];

int: max_children = 3;
int: min_children = 2;

% Variables
array[CHILD] of var 0..1: take;
var int: total_cost;

% Constraints
constraint total_cost = sum(c in CHILD)(cost[c] * take[c]);

constraint sum(c in CHILD)(take[c]) <= max_children;
constraint sum(c in CHILD)(take[c]) >= min_children;

% Bob is definitely taken
constraint take[Bob] = 1;

% Incompatibilities / implications
constraint take[Alice] + take[Diana] <= 1;                 % Alice => not Diana
constraint take[Bob] + take[Charlie] <= 1;                 % Bob => not Charlie
constraint take[Charlie] <= take[Diana];                   % Charlie => Diana
constraint take[Diana] <= take[Ella];                      % Diana => Ella

% Objective
solve minimize total_cost;