% Parameters
int: nHospitals = 4;                           % number of hospitals
set of int: H = 1..nHospitals;                 % hospital index set

array[H] of int: initial_supply = [480, 492, 74, 317];   % starting supplies at each hospital
array[H] of int: demand         = [ 61, 313, 93, 199];   % required supplies at each hospital

% transfer cost per unit from hospital i to hospital j
array[H, H] of int: cost =
  [|  0,  8, 42, 27
   | 17,  0, 13, 30
   |  4, 14,  0, 16
   | 33,  9, 42,  0
  |];

% Variables
% transfer[i,j] = units shipped from hospital i to hospital j
array[H, H] of var int: transfer;

% Constraints
%------------------------------------------------------------
% Non-negativity of transfers (shipments cannot be negative)
%------------------------------------------------------------
constraint
  forall(i in H, j in H) (
    transfer[i, j] >= 0
  );

%------------------------------------------------------------
% Disallow self-transfers (no shipment from a hospital to itself)
%------------------------------------------------------------
constraint
  forall(i in H) (
    transfer[i, i] = 0
  );

%------------------------------------------------------------
% Outgoing flow capacity: cannot ship out more than initial supply
%------------------------------------------------------------
constraint
  forall(i in H) (
    sum(j in H) transfer[i, j] <= initial_supply[i]
  );

%------------------------------------------------------------
% Demand satisfaction via flow balance:
% initial + incoming - outgoing must be at least the demand
%------------------------------------------------------------
constraint
  forall(j in H) (
    initial_supply[j]
    + sum(i in H) transfer[i, j]
    - sum(k in H) transfer[j, k]
    >= demand[j]
  );

% Objective
solve minimize sum(i in H, j in H)(cost[i, j] * transfer[i, j]);