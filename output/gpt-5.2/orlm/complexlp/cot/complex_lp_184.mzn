% Parameters (with values embedded)
int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: current = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% cost[i,j] = cost to move one car from i to j (0 if not allowed / i=j)
array[LOC, LOC] of int: cost =
[
|  0,  0, 11, 13, 28 |
|  0,  0, 18,  8, 46 |
|  0,  0,  0,  9, 27 |
|  0,  0,  0,  0, 20 |
|  0,  0,  0,  0,  0 |
];

% Allowed arcs: only those with specified costs (upper-triangular as given)
set of (int,int): ARCS =
  { (1,3), (1,4), (1,5),
    (2,3), (2,4), (2,5),
    (3,4), (3,5),
    (4,5) };

% Variables
array[LOC, LOC] of var 0..1000: x;  % x[i,j] cars moved from i to j (0 for disallowed arcs too)
var int: total_cost;

% Constraints
constraint forall(i in LOC, j in LOC where not ((i,j) in ARCS)) ( x[i,j] = 0 );
constraint forall(i in LOC) ( x[i,i] = 0 );

% Flow balance: final inventory at each location must equal needed
% final[i] = current[i] - sum_out + sum_in
constraint forall(i in LOC) (
  current[i]
  - sum(j in LOC) (x[i,j])
  + sum(j in LOC) (x[j,i])
  = needed[i]
);

% Objective
constraint total_cost = sum((i,j) in ARCS)( cost[i,j] * x[i,j] );
solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n"
];