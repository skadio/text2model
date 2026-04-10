% Farmer crop planning - embedded data

set of int: CROPS = 1..3;
int: WHEAT = 1;
int: CORN  = 2;
int: SOY   = 3;

array[CROPS] of int: cost = [10, 20, 30];

% Since the statement mentions "specific bounds" but does not provide numeric values,
% we use nonnegative integer acres as practical bounds.
array[CROPS] of int: lb = [0, 0, 0];
array[CROPS] of int: ub = [1000000, 1000000, 1000000];

array[CROPS] of var int: acres;
constraint forall(c in CROPS)(acres[c] >= lb[c] /\ acres[c] <= ub[c]);

% Constraints
constraint acres[WHEAT] + acres[CORN] <= 1000;
constraint acres[CORN] + acres[SOY]   <= 1500;
constraint acres[WHEAT] + acres[SOY] >= 500;
constraint acres[WHEAT] >= acres[CORN] + 200;

% Objective: minimize total cost
var int: total_cost = sum(c in CROPS)(cost[c] * acres[c]);
solve minimize total_cost;

output [
  "Wheat acres = ", show(acres[WHEAT]), "\n",
  "Corn acres  = ", show(acres[CORN]),  "\n",
  "Soy acres   = ", show(acres[SOY]),   "\n",
  "Total cost (rounded) = ", show(total_cost), "\n"
];