% Parameters
int: nClinics = 6;                                  % number of clinics
set of int: CLINICS = 1..nClinics;                  % clinic index set

array[CLINICS] of int: supply = [467, 121, 109, 131, 500, 10];   % current units at each clinic
array[CLINICS] of int: demand  = [261, 209, 135, 146, 488, 30];  % required units at each clinic

% transportation cost per unit from clinic i to clinic j
array[CLINICS, CLINICS] of int: cost =
[
  % to:   1   2   3   4   5   6
         0, 43,  8, 15, 37,  9,   % from 1
         9,  0, 50, 37, 50, 29,   % from 2
         3, 37,  0,  7, 18, 27,   % from 3
        15,  3,  3,  0,  2, 48,   % from 4
        34, 18, 44,  2,  0, 27,   % from 5
        36, 49, 29, 12, 33,  0    % from 6
];

% useful totals (must match for exact balancing to be feasible)
int: totalSupply = sum(i in CLINICS)(supply[i]);
int: totalDemand = sum(i in CLINICS)(demand[i]);

% Variables
array[CLINICS, CLINICS] of var 0..totalSupply: x;   % units shipped from clinic i to clinic j
var 0..intmax: totalCost;                           % total transportation cost

% Constraints
%--- Feasibility: total supply must match total demand (otherwise no exact balance possible) ---
constraint totalSupply = totalDemand;

%--- Structural: forbid shipments from a clinic to itself ---
constraint forall(i in CLINICS)(x[i,i] = 0);

%--- Flow conservation: each clinic ends with exactly its demand ---
constraint forall(i in CLINICS)(
  supply[i]
  + sum(j in CLINICS)(x[j,i])    % incoming to i
  - sum(j in CLINICS)(x[i,j])    % outgoing from i
  = demand[i]
);

%--- Define total transportation cost from shipment decisions ---
constraint totalCost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;