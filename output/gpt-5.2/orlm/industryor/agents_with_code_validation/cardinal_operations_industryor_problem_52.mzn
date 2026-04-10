% Parameters
% Number of children
int: n = 6;

% Index set for children
set of int: CHILDREN = 1..n;

% Child indices (fixed mapping)
int: HARRY    = 1;
int: HERMIONE = 2;
int: RON      = 3;
int: FRED     = 4;
int: GEORGE   = 5;
int: GINNY    = 6;

% Cost of taking each child (in dollars), indexed by CHILDREN
array[CHILDREN] of int: cost = [1200, 1650, 750, 800, 800, 1500];

% Limits and requirements
int: max_children = 4;
int: min_children = 3;

% Variables
% take[i] = 1 if child i is taken on the trip, else 0
array[CHILDREN] of var 0..1: take;

% Total number of children taken
var 0..n: total_taken;

% Total cost of the trip
var 0..sum(cost): total_cost;

% Constraints
% Link aggregate variables to decision variables
constraint total_taken = sum(i in CHILDREN)(take[i]);
constraint total_cost  = sum(i in CHILDREN)(cost[i] * take[i]);

% Trip size limits (at most 4, at least 3)
constraint total_taken <= max_children;
constraint total_taken >= min_children;

% Ginny must be taken
constraint take[GINNY] = 1;

% Harry conflicts: if Harry is taken, Fred and George are not taken
constraint take[HARRY] + take[FRED]   <= 1;
constraint take[HARRY] + take[GEORGE] <= 1;

% George implies Fred and Hermione
constraint take[GEORGE] <= take[FRED];
constraint take[GEORGE] <= take[HERMIONE];

% Objective
solve minimize total_cost;

% (Optional) Output for readability
output [
  "take = ", show(take), "\n",
  "total_taken = ", show(total_taken), "\n",
  "total_cost = ", show(total_cost), "\n"
];