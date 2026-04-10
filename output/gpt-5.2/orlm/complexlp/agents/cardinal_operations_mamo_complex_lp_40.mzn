% Parameters
int: nWarehouses = 6;                          % number of warehouses
set of int: W = 1..nWarehouses;                % warehouse index set

array[W] of int: current = [497, 39, 416, 71, 445, 471];   % current inventory at each warehouse
array[W] of int: need    = [161, 257, 252, 251, 372, 370]; % required inventory at each warehouse

% transportation cost per unit shipped from i to j (0 on diagonal)
array[W, W] of int: cost =
  [| 0,  5,  7,  5, 27, 49
   |31,  0, 14, 31,  3,  4
   | 9, 13,  0, 23, 38, 19
   |47, 34,  7,  0, 34, 35
   |21, 11,  6,  7,  0, 50
   |28, 41, 34, 17, 32,  0 |];

int: total_current = sum(i in W)(current[i]);  % total available product
int: total_need    = sum(i in W)(need[i]);     % total required product

% Variables
% x[i,j] = units shipped from warehouse i to warehouse j
array[W, W] of var 0..total_current: x;

% total transportation cost to minimize
var 0..(total_current * max(i in W, j in W)(cost[i,j])): total_cost;

% Constraints
%-------------------------------
% Feasibility check: global supply must match global demand
%-------------------------------
constraint total_current = total_need;

%-------------------------------
% No self-shipment (diagonal must be zero)
%-------------------------------
constraint forall(i in W)(
  x[i,i] = 0
);

%-------------------------------
% Flow balance at each warehouse:
% current - outgoing + incoming = need
%-------------------------------
constraint forall(i in W)(
  current[i]
  - sum(j in W)(x[i,j])
  + sum(j in W)(x[j,i])
  = need[i]
);

%-------------------------------
% Total transportation cost definition
%-------------------------------
constraint total_cost =
  sum(i in W, j in W)(
    cost[i,j] * x[i,j]
  );

% Objective
solve minimize total_cost;