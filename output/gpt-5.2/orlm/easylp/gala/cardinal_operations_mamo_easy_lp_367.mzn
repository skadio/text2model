include "globals.mzn";

% Data (embedded from problem statement)
set of int: PROJECTS = 1..4;
array[PROJECTS] of int: cost = [1000, 2000, 3000, 4000];
array[PROJECTS] of int: max_workers = [10, 15, 12, 8];

% Decision variables: number of workers assigned to each project
array[PROJECTS] of var 0..max(max_workers): w;

% Respect individual project bounds
constraint forall(p in PROJECTS)(w[p] <= max_workers[p]);

% Constraints
constraint w[1] + w[2] <= 20;                    % P1 + P2 <= 20
constraint w[2] + w[3] >= 10;                    % P2 + P3 >= 10
constraint abs(w[3] - w[4]) <= 5;                % |P3 - P4| <= 5
constraint 2*w[1] + 3*w[2] - w[4] >= 15;         % 2*P1 + 3*P2 - P4 >= 15

% Objective: minimize total cost
var int: total_cost = sum(p in PROJECTS)(cost[p] * w[p]);

solve minimize total_cost;

output [
  "Workers (P1..P4) = ", show(w), "\n",
  "Total cost = $", show(total_cost), "\n"
];