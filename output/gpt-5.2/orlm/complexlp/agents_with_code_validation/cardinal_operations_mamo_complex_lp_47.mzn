% Parameters
int: nRegions = 6;                          % Number of regions
set of int: R = 1..nRegions;                % Region index set

array[R] of int: stock =                    % Initial stock at each region
  [319, 281, 247, 237, 29, 453];

array[R] of int: need =                     % Required amount at each region
  [243, 243, 124, 202, 84, 28];

array[R, R] of int: cost =                  % Transport cost from i -> j
  [|  0, 11, 30, 12, 48, 23
   |  1,  0, 27,  9, 26, 13
   | 29,  6,  0, 27, 13, 44
   |  6, 50, 12,  0, 19, 32
   | 26, 13, 29,  2,  0, 24
   |  9, 26,  2, 37, 22,  0 |];

% Derived totals (used for feasibility check and safe bounds)
int: totalStock = sum(r in R)(stock[r]);
int: totalNeed  = sum(r in R)(need[r]);

% Variables
array[R, R] of var 0..totalStock: ship;     % Units shipped from region i to region j
var 0..(totalStock * max(i in R, j in R)(cost[i,j])): totalCost;  % Total transport cost (safe upper bound)

% Constraints
%-------------------------------
% Balance feasibility (given data must balance exactly)
%-------------------------------
constraint totalStock = totalNeed;

%-------------------------------
% No self-shipping
%-------------------------------
constraint forall(i in R)(
  ship[i,i] = 0
);

%-------------------------------
% Outgoing shipments limited by stock at origin
%-------------------------------
constraint forall(i in R)(
  sum(j in R)(ship[i,j]) <= stock[i]
);

%-------------------------------
% Flow conservation: each region ends exactly at its need
% stock - outgoing + incoming = need
%-------------------------------
constraint forall(r in R)(
  stock[r] - sum(j in R)(ship[r,j]) + sum(i in R)(ship[i,r]) = need[r]
);

%-------------------------------
% Total cost definition
%-------------------------------
constraint totalCost =
  sum(i in R, j in R)(cost[i,j] * ship[i,j]);

% Objective
solve minimize totalCost;