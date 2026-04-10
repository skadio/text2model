include "globals.mzn";

% Parameters
int: n = 5;                             % number of shops/locations
set of int: SHOPS = 1..n;               % shop indices (1=Shop1, ..., 5=Shop5)

% Travel cost matrix (cost[i,j] = cost to go from shop i to shop j)
array[SHOPS, SHOPS] of int: cost =
  [|  0, 13, 87, 76, 50
   | 13,  0, 15, 65, 85
   | 87, 15,  0, 45, 81
   | 76, 65, 45,  0, 80
   | 50, 85, 81, 80,  0
  |];

int: start = 1;                         % starting (and ending) shop index (Shop1)

% Variables
array[SHOPS] of var SHOPS: succ;        % succ[i] = next shop visited after i
var int: total_cost;                    % total travel cost of the tour

% Constraints
% Enforce a single Hamiltonian cycle visiting all shops exactly once
constraint circuit(succ);

% Total travel cost accumulation from successor arcs
constraint total_cost = sum(i in SHOPS)(cost[i, succ[i]]);

% Simple bounds for solver guidance
int: maxArc = max([cost[i,j] | i in SHOPS, j in SHOPS]);
constraint total_cost >= 0;
constraint total_cost <= n * maxArc;

% Start node validity (tour includes all nodes anyway)
constraint start in SHOPS;

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];