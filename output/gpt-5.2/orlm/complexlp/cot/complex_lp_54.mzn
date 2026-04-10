% Parameters (with values embedded)
int: N = 4;
set of int: D = 1..N;

array[D] of int: supply = [412, 92, 265, 342];
array[D] of int: demand = [74, 334, 61, 352];

array[D,D] of int: cost = 
[| 0, 20, 43,  1
 | 42,  0, 32, 13
 | 27,  5,  0, 10
 | 30, 22,  9,  0 |];

% Variables
array[D,D] of var int: x;  % shipped from i to j

% Constraints
constraint forall(i in D, j in D) (x[i,j] >= 0);

% No self-shipping (optional but tightens the model)
constraint forall(i in D) (x[i,i] = 0);

% Flow balance: final amount in each district equals demand
% supply[i] - outgoing + incoming = demand[i]
constraint forall(i in D)(
  supply[i]
  - sum(j in D)(x[i,j])
  + sum(j in D)(x[j,i])
  = demand[i]
);

% Objective
solve minimize sum(i in D, j in D)(cost[i,j] * x[i,j]);