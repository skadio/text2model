% Parameters (with values embedded)
int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: present = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% Cost matrix (0 on diagonal; symmetric costs for moves between regions)
array[LOC, LOC] of int: cost =
array2d(LOC, LOC,
[
  0,  0, 13, 11, 28,
  0,  0, 18,  8, 46,
 13, 18,  0,  9, 27,
 11,  8,  9,  0, 20,
 28, 46, 27, 20,  0
]);

% Upper bound for any single flow variable (safe global bound)
int: MAXFLOW = sum(present);

% Variables
% x[i,j] = number of cars moved from location i to location j
array[LOC, LOC] of var 0..MAXFLOW: x;

% Constraints
% No self-moves
constraint forall(i in LOC) ( x[i,i] = 0 );

% Disallow unspecified arcs by forcing their cost to 0 already; instead explicitly forbid
% the missing directions by allowing movement only between distinct locations (cost given symmetrically).
% (All distinct pairs are allowed here via the symmetric costs provided.)

% Flow balance at each location: final inventory must equal needed
% final(i) = present(i) - outflow(i) + inflow(i) = needed(i)
constraint forall(i in LOC) (
  present[i]
  - sum(j in LOC where j != i)(x[i,j])
  + sum(j in LOC where j != i)(x[j,i])
  = needed[i]
);

% Objective
var int: total_cost = sum(i in LOC, j in LOC where i != j)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Total cost (nearest dollar): ", show(total_cost), "\n"
];