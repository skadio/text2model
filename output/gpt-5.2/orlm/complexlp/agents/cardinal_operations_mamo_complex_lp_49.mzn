% Parameters
int: n = 7;                                   % Number of distribution centers
set of int: CENTERS = 1..n;                   % Index set for centers

array[CENTERS] of int: initial_supply =       % Starting units at each center
  [97, 458, 473, 380, 34, 399, 163];

array[CENTERS] of int: required_supply =      % Required units at each center
  [119, 275, 36, 459, 17, 128, 425];

array[CENTERS, CENTERS] of int: cost =        % Transfer cost from i to j
  [|  0, 41, 42, 31, 39,  2, 18
   | 48,  0,  9, 22, 47, 29, 39
   | 36, 22,  0, 29, 45, 33, 45
   | 19,  5, 10,  0,  3, 42, 20
   | 13, 10, 21,  7,  0, 35, 11
   |  5, 35, 29, 16, 40,  0,  9
   |  7, 24, 26, 38, 33, 13,  0 |];

int: total_initial = sum(i in CENTERS)(initial_supply[i]);
int: total_required = sum(i in CENTERS)(required_supply[i]);
int: max_total_flow = total_initial;          % Safe upper bound on any total shipped amount


% Variables
array[CENTERS, CENTERS] of var 0..max_total_flow: ship;  % Units shipped from i to j
var 0..(max_total_flow * max(cost)): total_cost;         % Total redistribution cost


% Constraints
%-----------------------------------------------------------------------
% Flow conservation / demand satisfaction:
% For each center j:
% initial supply + incoming shipments - outgoing shipments = required supply
%-----------------------------------------------------------------------
constraint
  forall(j in CENTERS) (
    initial_supply[j]
    + sum(i in CENTERS where i != j)(ship[i, j])
    - sum(k in CENTERS where k != j)(ship[j, k])
    = required_supply[j]
  );

%-----------------------------------------------------------------------
% No self-shipment (avoid meaningless ship[i,i])
%-----------------------------------------------------------------------
constraint
  forall(i in CENTERS) (
    ship[i, i] = 0
  );

%-----------------------------------------------------------------------
% Total supply must equal total requirement for feasibility
%-----------------------------------------------------------------------
constraint
  total_initial = total_required;

%-----------------------------------------------------------------------
% Define total cost from shipment decisions and per-unit transfer costs
%-----------------------------------------------------------------------
constraint
  total_cost = sum(i in CENTERS, j in CENTERS) (cost[i, j] * ship[i, j]);


% Objective
solve minimize total_cost;