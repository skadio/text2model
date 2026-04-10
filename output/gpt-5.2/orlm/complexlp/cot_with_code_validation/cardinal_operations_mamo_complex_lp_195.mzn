% Parameters
int: N = 5;
set of int: R = 1..N;

array[R,R] of int: cost = array2d(R,R,[
  0, 10, 12, 17, 34,
  10, 0, 18, 8, 46,
  12, 18, 0, 9, 27,
  17, 8, 9, 0, 20,
  34, 46, 27, 20, 0
]);

array[R] of int: current = [115, 385, 410, 480, 610];
array[R] of int: needed  = [300, 400, 800, 200, 300];

array[R] of int: supply = [ max(0, current[i] - needed[i]) | i in R ];
array[R] of int: demand = [ max(0, needed[i] - current[i]) | i in R ];

int: total_supply = sum(i in R)(supply[i]);
int: total_demand = sum(i in R)(demand[i]);

% Variables
array[R,R] of var 0..total_supply: x;

% Constraints
constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  sum(i in R)(x[i,j]) = demand[j]
);

constraint total_supply >= total_demand;

% Objective
var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;