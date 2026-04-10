% Parameters (with values embedded)
int: nProjects = 4;
set of int: P = 1..nProjects;

array[P] of int: costPerWorker = [1000, 2000, 3000, 4000];
array[P] of int: maxWorkers    = [10, 15, 12, 8];

% Variables
array[P] of var int: workers;
var int: totalCost;

% Constraints
constraint forall(p in P) (
  0 <= workers[p] /\ workers[p] <= maxWorkers[p]
);

% P1 + P2 <= 20
constraint workers[1] + workers[2] <= 20;

% P2 + P3 >= 10
constraint workers[2] + workers[3] >= 10;

% |P3 - P4| <= 5
constraint abs(workers[3] - workers[4]) <= 5;

% 2*P1 + 3*P2 - P4 >= 15
constraint 2*workers[1] + 3*workers[2] - workers[4] >= 15;

% Objective
constraint totalCost = sum(p in P)(costPerWorker[p] * workers[p]);

solve minimize totalCost;

output [
  "workers(P1) = ", show(workers[1]), "\n",
  "workers(P2) = ", show(workers[2]), "\n",
  "workers(P3) = ", show(workers[3]), "\n",
  "workers(P4) = ", show(workers[4]), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];