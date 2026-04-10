% Parameters
int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: current = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% cost[i,j] = cost to move one car from i to j (0 if i==j; large if not allowed)
int: BIG = 1000000;
array[LOC, LOC] of int: cost =
  array2d(LOC, LOC,
  [
    0,   BIG, 11, 13, 28,
    BIG, 0,   18,  8, 46,
    BIG, BIG, 0,   9, 27,
    BIG, BIG, BIG, 0, 20,
    BIG, BIG, BIG, BIG, 0
  ]);

int: totalCars = sum(i in LOC)(current[i]);

% Variables
array[LOC, LOC] of var 0..totalCars: x;

var 0..(totalCars * 1000): totalCost;

% Constraints
constraint forall(i in LOC)(x[i,i] = 0);

% Disallow moves that are not listed (upper triangle only) by forcing x[i,j]=0 when cost is BIG
constraint forall(i in LOC, j in LOC where cost[i,j] >= BIG)(x[i,j] = 0);

% Flow balance: final cars at each location must equal needed
% final[i] = current[i] - outflow(i) + inflow(i)
constraint forall(i in LOC)(
  current[i]
  - sum(j in LOC)(x[i,j])
  + sum(j in LOC)(x[j,i])
  = needed[i]
);

% Define objective expression
constraint totalCost = sum(i in LOC, j in LOC)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;