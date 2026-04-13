% Parameters
int: nClinics = 6;                             % Number of clinics
set of int: CLINICS = 1..nClinics;

array[CLINICS] of int: supply =                % Current supplies at each clinic
  [467, 121, 109, 131, 500, 10];

array[CLINICS] of int: demand =                % Required supplies at each clinic
  [261, 209, 135, 146, 488, 30];

% Transportation cost per unit from clinic i to clinic j
% (Diagonal costs are set to 0; shipments to self will be forced to 0 by constraints)
array[CLINICS, CLINICS] of int: cost =
  array2d(CLINICS, CLINICS,
  [  0, 43,  8, 15, 37,  9,
     9,  0, 50, 37, 50, 29,
     3, 37,  0,  7, 18, 27,
    15,  3,  3,  0,  2, 48,
    34, 18, 44,  2,  0, 27,
    36, 49, 29, 12, 33,  0 ]);

% Total supply (must equal total demand for feasibility)
int: totalSupply = sum(i in CLINICS)(supply[i]);
int: totalDemand = sum(i in CLINICS)(demand[i]);

% Variables
% x[i,j] = units shipped from clinic i to clinic j
array[CLINICS, CLINICS] of var 0..totalSupply: x;

% Total transportation cost
var 0..(totalSupply * max(i in CLINICS, j in CLINICS)(cost[i,j])): totalCost;

% Constraints
% Ensure overall feasibility (balance) and disallow self-shipments
constraint totalSupply = totalDemand;
constraint forall(i in CLINICS)(x[i,i] = 0);

% Define totalCost
constraint totalCost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

% Flow conservation / demand satisfaction:
% For each clinic j, starting supply plus incoming shipments minus outgoing shipments
% must equal its exact demand.
constraint
  forall(j in CLINICS)(
    supply[j]
    + sum(i in CLINICS where i != j)(x[i,j])
    - sum(k in CLINICS where k != j)(x[j,k])
    = demand[j]
  );

% Outgoing capacity:
% A clinic cannot ship out more than its available initial supply plus what it receives.
constraint
  forall(i in CLINICS)(
    sum(j in CLINICS where j != i)(x[i,j])
    <= supply[i] + sum(k in CLINICS where k != i)(x[k,i])
  );

% (Removed the provided "optional tightening" since it is a tautology and adds no strength)

% Objective
solve minimize totalCost;

% Output (optional, helpful for inspection)
output [
  "Minimum total cost = ", show(totalCost), "\n",
  "Shipments x[i,j]:\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in CLINICS]) ++ "\n"
         | i in CLINICS ])
];