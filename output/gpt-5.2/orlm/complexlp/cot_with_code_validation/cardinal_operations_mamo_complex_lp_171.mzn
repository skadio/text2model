include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: M = 6; % distribution centers
int: N = 7; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, ST] of int: trans_cost =
  array2d(DC, ST,
  [ 2,3,3,3,5,4,3,
    5,2,4,2,4,5,1,
    4,2,5,4,1,1,3,
    3,2,4,4,3,4,4,
    1,3,5,3,5,1,2,
    4,1,4,2,2,1,2 ]);

array[ST] of int: demand = [964, 739, 491, 766, 854, 827, 908];
array[DC] of int: capacity = [1575, 834, 1005, 1904, 1825, 1821];

int: total_demand = sum(s in ST)(demand[s]);
int: max_ship = max(demand);
int: max_tc = max([trans_cost[d,s] | d in DC, s in ST]);

%----------------------------
% Decision variables
%----------------------------
array[DC] of var bool: open;
array[DC, ST] of var 0..max_ship: ship;

%----------------------------
% Constraints
%----------------------------
constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

%----------------------------
% Objective (direct; no huge-domain total_cost var)
%----------------------------
var int: total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d,s] * ship[d,s]);

solve :: int_search([ship[d,s] | d in DC, s in ST] ++ [bool2int(open[d]) | d in DC],
                    first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];