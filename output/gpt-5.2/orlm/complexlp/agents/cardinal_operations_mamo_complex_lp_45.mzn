% Parameters
int: nClinics = 4;                           % Number of clinics
set of int: CLINICS = 1..nClinics;           % Clinic index set

array[CLINICS] of int: initialStock =        % Initial stock at each clinic
  [330, 294, 474, 86];

array[CLINICS] of int: requiredStock =       % Required stock at each clinic
  [476, 92, 385, 203];

array[CLINICS, CLINICS] of int: cost =       % Transportation cost per unit between clinics
  [|  0,  2, 12, 19
   | 28,  0,  9, 10
   | 23, 46,  0,  7
   | 19, 16, 23,  0 |];

int: totalSupply = sum(i in CLINICS)(initialStock[i]);   % Total available supply
int: totalDemand = sum(i in CLINICS)(requiredStock[i]);  % Total required demand


% Variables
array[CLINICS, CLINICS] of var int: ship;    % ship[i,j] = units shipped from clinic i to clinic j (>= 0)
var int: totalCost;                          % Total transportation cost (to minimize)


% Constraints
%--- Bounds / domain constraints for variables
constraint forall(i,j in CLINICS)(ship[i,j] >= 0);

% Reasonable upper bound: can't ship more than totalSupply on any arc
constraint forall(i,j in CLINICS)(ship[i,j] <= totalSupply);

% Disallow self-shipment (keeps model clean; cost already 0 on diagonal)
constraint forall(i in CLINICS)(ship[i,i] = 0);

% Define total cost
constraint totalCost = sum(i,j in CLINICS)(cost[i,j] * ship[i,j]);

%--- Feasibility: total supply must be enough to satisfy total demand
constraint totalSupply >= totalDemand;

%--- Flow balance / stock satisfaction at each clinic
% Initial stock + incoming shipments - outgoing shipments must meet (at least) the required stock
constraint
  forall(k in CLINICS) (
    initialStock[k]
    + sum(i in CLINICS)(ship[i,k])
    - sum(j in CLINICS)(ship[k,j])
    >= requiredStock[k]
  );

%--- Optional strengthening: prevent shipping out of a clinic beyond what it initially has plus what it receives
% (This avoids "creating" flow that is not available at a clinic.)
constraint
  forall(i in CLINICS) (
    sum(j in CLINICS)(ship[i,j]) <= initialStock[i] + sum(k in CLINICS)(ship[k,i])
  );


% Objective
solve minimize totalCost;