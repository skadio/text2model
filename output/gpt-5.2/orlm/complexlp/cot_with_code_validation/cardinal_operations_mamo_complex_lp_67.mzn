include "globals.mzn";

% Parameters
int: N = 5;
set of int: W = 1..N; % 1=A, 2=B, 3=C, 4=D, 5=E

array[W, W] of int: cost =
  [| 0, 15, 88, 54, 92
   | 15, 0, 29, 98, 33
   | 88, 29, 0, 96, 96
   | 54, 98, 96, 0, 63
   | 92, 33, 96, 63, 0 |];

int: BIG = N * max([cost[i,j] | i in W, j in W]);

% Variables
array[W] of var W: succ;      % successor of each warehouse in the tour
array[W] of var 0..N-1: pos;  % position/order (optional strengthening)
var 0..BIG: total_cost;

% Constraints
constraint circuit(succ);

% Optional MTZ-style strengthening (consistent with circuit)
constraint pos[1] = 0;
constraint forall(i in 2..N)(pos[i] >= 1 /\ pos[i] <= N-1);
constraint forall(i in W, j in 2..N where i != j)(
  pos[i] + 1 <= pos[j] + (N-1) * (1 - bool2int(succ[i] = j))
);

constraint total_cost = sum(i in W)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];