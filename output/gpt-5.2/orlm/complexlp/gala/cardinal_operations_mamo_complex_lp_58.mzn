include "globals.mzn";

% Medical supplies redistribution (transportation problem)

int: n = 5;
set of int: R = 1..n;

array[R] of int: supply = [133, 189, 446, 346, 184];
array[R] of int: demand = [146, 270, 313, 102, 412];

array[R,R] of int: cost =
[
  % to:   1   2   3   4   5
        [0, 24, 32, 44, 46], % from 1
        [41, 0,  6, 11, 49], % from 2
        [40, 10, 0, 40, 45], % from 3
        [22, 22, 34, 0,  1], % from 4
        [46, 14, 35, 36, 0]  % from 5
];

% Flow[i,j] = units shipped from region i to region j
array[R,R] of var 0..max(supply): flow;

% No reason to ship from a region to itself
constraint forall(i in R)(flow[i,i] = 0);

% Outgoing from each region cannot exceed its available supply
constraint forall(i in R)(
  sum(j in R)(flow[i,j]) <= supply[i]
);

% Incoming to each region plus what it keeps must meet its demand:
% supply[i] - outgoing + incoming >= demand[i]
constraint forall(i in R)(
  supply[i] - sum(j in R)(flow[i,j]) + sum(j in R)(flow[j,i]) >= demand[i]
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * flow[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Flow matrix (from rows to columns):\n",
  show(flow), "\n"
];