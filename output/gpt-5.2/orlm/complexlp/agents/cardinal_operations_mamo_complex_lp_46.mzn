% Parameters
int: nHospitals = 7;                                   % Number of hospitals
set of int: H = 1..nHospitals;                         % Hospital index set

array[H] of int: initialStock = [160, 353, 171, 193, 102, 429, 284];  % Current supply at each hospital
array[H] of int: requiredStock = [19, 138, 110, 446, 341, 428, 47];   % Required supply at each hospital

% Transportation cost matrix (cost[i,j] = cost to ship 1 unit from i to j)
% Diagonal set to 0 (no self-shipment needed).
array[H, H] of int: cost =
[
|  0, 12, 47, 39,  4, 21, 31
| 14,  0, 39, 12, 31, 29, 15
| 15,  6,  0, 26, 12,  5,  3
| 39, 47, 42,  0, 33, 48,  2
| 35, 25, 46, 12,  0, 25, 45
| 39, 28, 28, 11, 16,  0, 13
| 42, 43, 49, 41, 41, 18,  0
];

% Useful derived bounds for shipment variables
int: totalSupply = sum(i in H)(initialStock[i]);       % Total available supply
int: maxUnitShip = totalSupply;                         % Safe upper bound for any arc flow

% Variables
array[H, H] of var 0..maxUnitShip: ship;               % ship[i,j] = units shipped from hospital i to hospital j
var 0..(maxUnitShip * max(cost)): totalCost;           % Total transportation cost

% Constraints

%-----------------------------------------------------------------------
% No self-shipment (diagonal flows must be zero)
%-----------------------------------------------------------------------
constraint
  forall(i in H) (
    ship[i,i] = 0
  );

%-----------------------------------------------------------------------
% Flow conservation / demand satisfaction at each hospital:
% finalStock[i] = initialStock[i] - outgoing + incoming >= requiredStock[i]
%-----------------------------------------------------------------------
constraint
  forall(i in H) (
    initialStock[i]
    - sum(j in H where j != i)(ship[i,j])
    + sum(j in H where j != i)(ship[j,i])
    >= requiredStock[i]
  );

%-----------------------------------------------------------------------
% Cannot ship out more than available at any hospital
%-----------------------------------------------------------------------
constraint
  forall(i in H) (
    sum(j in H where j != i)(ship[i,j]) <= initialStock[i]
  );

%-----------------------------------------------------------------------
% Total cost definition
%-----------------------------------------------------------------------
constraint
  totalCost = sum(i in H, j in H) (ship[i,j] * cost[i,j]);

% Objective
solve minimize totalCost;