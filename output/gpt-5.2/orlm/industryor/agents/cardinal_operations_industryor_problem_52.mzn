% Parameters

% Children index set
int: nChildren = 6;
set of int: CHILDREN = 1..nChildren;

% Child names (for readability/output)
array[CHILDREN] of string: childName =
  ["Harry", "Hermione", "Ron", "Fred", "George", "Ginny"];

% Costs per child (aligned with CHILDREN index order above)
array[CHILDREN] of int: cost = [1200, 1650, 750, 800, 800, 1500];

% Special indices (to make constraints readable)
int: HARRY    = 1;
int: HERMIONE = 2;
int: RON      = 3;
int: FRED     = 4;
int: GEORGE   = 5;
int: GINNY    = 6;

% Capacity / requirements
int: maxChildren = 4;
int: minChildren = 3;


% Variables

% take[c] = 1 if child c is taken on the trip, else 0
array[CHILDREN] of var 0..1: take;

% Total cost to minimize
var int: totalCost;


% Constraints

% --- Total cost definition (link decision variables to objective expression) ---
constraint
  totalCost = sum(c in CHILDREN)(cost[c] * take[c]);

% --- Capacity constraints: at least minChildren and at most maxChildren taken ---
constraint
  sum(c in CHILDREN)(take[c]) <= maxChildren;

constraint
  sum(c in CHILDREN)(take[c]) >= minChildren;

% --- Mandatory child: Ginny must be taken ---
constraint
  take[GINNY] = 1;

% --- Incompatibilities with Harry ---
% If Harry is taken, Fred is not taken
constraint
  take[HARRY] + take[FRED] <= 1;

% If Harry is taken, George is not taken
constraint
  take[HARRY] + take[GEORGE] <= 1;

% --- Implications from taking George ---
% If George is taken, Fred must also be taken
constraint
  take[GEORGE] <= take[FRED];

% If George is taken, Hermione must also be taken
constraint
  take[GEORGE] <= take[HERMIONE];


% Objective
solve minimize totalCost;