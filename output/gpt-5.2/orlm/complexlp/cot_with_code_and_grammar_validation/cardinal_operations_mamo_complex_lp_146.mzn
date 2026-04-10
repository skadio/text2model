% Parameters
int: I = 9; % distribution centers
int: J = 8; % retail stores

array[1..I] of int: open_cost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

% NOTE: The problem description does not provide the full 9x8 transport-cost matrix.
% This model requires all costs to be specified to compute an optimal total cost.
% Replace the placeholder matrix below with the actual costs (cost[i,j]).
array[1..I, 1..J] of int: trans_cost = array2d(1..I, 1..J, [
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0
]);

% NOTE: The problem description does not provide the explicit 8 store demands and 9 center capacities.
% Replace the placeholders below with the actual values.
array[1..J] of int: demand = [0,0,0,0,0,0,0,0];
array[1..I] of int: capacity = [0,0,0,0,0,0,0,0,0];

int: total_demand = sum(j in 1..J)(demand[j]);

% Variables
array[1..I] of var 0..1: open;
array[1..I, 1..J] of var 0..total_demand: ship;

var int: total_cost;

% Constraints
constraint
  forall(j in 1..J) (
    sum(i in 1..I)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in 1..I) (
    sum(j in 1..J)(ship[i,j]) <= capacity[i] * open[i]
  );

constraint
  total_cost =
    sum(i in 1..I)(open_cost[i] * open[i]) +
    sum(i in 1..I, j in 1..J)(trans_cost[i,j] * ship[i,j]);

% Objective
solve minimize total_cost;