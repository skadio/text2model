% Parameters
% Number of orders
int: nOrders = 3;
set of int: ORDERS = 1..nOrders;

% Order widths (meters) and required lengths (meters)
array[ORDERS] of float: order_width  = [0.5, 0.7, 0.9];
array[ORDERS] of float: order_length = [1000.0, 3000.0, 2000.0];

% Standard jumbo roll widths available (meters)
int: nJumbo = 2;
set of int: JUMBO = 1..nJumbo;
array[JUMBO] of float: jumbo_width = [1.0, 2.0];

% Derived: total demanded area (m^2) (useful for bookkeeping)
float: total_demand_area = sum(o in ORDERS)(order_width[o] * order_length[o]);

% Predefined feasible cutting patterns for each jumbo width
% Patterns for 1.0m jumbo (P1):
%  p=1: (2,0,0)   => 0.5+0.5
%  p=2: (0,1,0)   => 0.7
%  p=3: (0,0,1)   => 0.9
int: nPat1 = 3;
set of int: P1 = 1..nPat1;
array[P1, ORDERS] of int: pat1 =
[
  [2,0,0],
  [0,1,0],
  [0,0,1]
];

% Patterns for 2.0m jumbo (P2):
%  p=1: (4,0,0)   => 0.5x4
%  p=2: (2,1,0)   => 0.5+0.5+0.7
%  p=3: (2,0,1)   => 0.5+0.5+0.9
%  p=4: (0,2,0)   => 0.7+0.7
%  p=5: (0,1,1)   => 0.7+0.9
%  p=6: (0,0,2)   => 0.9+0.9
int: nPat2 = 6;
set of int: P2 = 1..nPat2;
array[P2, ORDERS] of int: pat2 =
[
  [4,0,0],
  [2,1,0],
  [2,0,1],
  [0,2,0],
  [0,1,1],
  [0,0,2]
];

% Variables
% Decision variables: length (meters) run for each pattern (continuous, since splicing allowed)
array[P1] of var float: len_pat1; % length assigned to each 1.0m pattern
array[P2] of var float: len_pat2; % length assigned to each 2.0m pattern

% Produced lengths per order (meters) induced by patterns
array[ORDERS] of var float: produced_length;

% Waste area (m^2) from each jumbo width type and total
var float: waste_area_1m;
var float: waste_area_2m;
var float: total_waste_area;

% Constraints
%-------------------------------
% Non-negativity of run lengths
%-------------------------------
constraint forall(p in P1)(len_pat1[p] >= 0.0);
constraint forall(p in P2)(len_pat2[p] >= 0.0);

%----------------------------------------------------
% Compute produced length per order induced by patterns
% produced_length[o] = sum_p (number_of_strips[o] * run_length[p])
%----------------------------------------------------
constraint
  forall(o in ORDERS)(
    produced_length[o] =
      sum(p in P1)(int2float(pat1[p,o]) * len_pat1[p]) +
      sum(p in P2)(int2float(pat2[p,o]) * len_pat2[p])
  );

%--------------------------------------------
% Demand satisfaction (must meet required length)
%--------------------------------------------
constraint forall(o in ORDERS)(produced_length[o] >= order_length[o]);

%----------------------------------------------------
% Waste area accounting per jumbo type:
% waste = (jumbo width - used width in pattern) * run length
%----------------------------------------------------
constraint
  waste_area_1m =
    sum(p in P1)(
      (jumbo_width[1] - sum(o in ORDERS)(order_width[o] * int2float(pat1[p,o])))
      * len_pat1[p]
    );

constraint
  waste_area_2m =
    sum(p in P2)(
      (jumbo_width[2] - sum(o in ORDERS)(order_width[o] * int2float(pat2[p,o])))
      * len_pat2[p]
    );

%--------------------------------------------
% Total waste area
%--------------------------------------------
constraint total_waste_area = waste_area_1m + waste_area_2m;

%--------------------------------------------
% Sanity: waste areas cannot be negative
%--------------------------------------------
constraint waste_area_1m >= 0.0;
constraint waste_area_2m >= 0.0;
constraint total_waste_area >= 0.0;

% Objective
solve minimize total_waste_area;