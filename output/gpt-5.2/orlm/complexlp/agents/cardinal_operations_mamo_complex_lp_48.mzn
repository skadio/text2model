% Parameters
int: nFacilities = 7;                           % Number of healthcare facilities
set of int: FACILITIES = 1..nFacilities;        % Facility index set

array[FACILITIES] of int: initialSupply =       % Initial supplies at each facility
  [229, 345, 231, 164, 354, 437, 265];

array[FACILITIES] of int: requiredSupply =      % Required supplies at each facility
  [158,  14, 326, 432, 207, 215, 233];

array[FACILITIES, FACILITIES] of int: cost =    % Transportation cost matrix (i -> j)
  [|  0, 26,  8,  7, 34, 35, 34
   | 41,  0, 27, 31,  3, 33, 36
   | 20, 49,  0, 48, 21, 38, 42
   | 10, 35, 26,  0, 21, 33, 31
   | 21, 30, 24, 25,  0,  5,  8
   | 27, 34, 34, 26, 27,  0, 43
   | 38, 20, 11, 43, 49,  9,  0 |];

int: totalSupply = sum(i in FACILITIES)(initialSupply[i]);   % Total initial supply
int: totalDemand = sum(i in FACILITIES)(requiredSupply[i]);  % Total required supply


% Variables
array[FACILITIES, FACILITIES] of var 0..totalSupply: ship;   % Units shipped from facility i to facility j

% Upper bound: totalSupply * max cost entry (computed over all i,j)
int: maxCost = max(i in FACILITIES, j in FACILITIES)(cost[i,j]);
var 0..(totalSupply * maxCost): totalCost;                   % Total transportation cost


% Constraints

% Sanity check: total supply must equal total demand for exact fulfillment
constraint totalSupply = totalDemand;

% Shipping balance at each facility:
% initial + inflow - outflow = required
constraint
  forall(i in FACILITIES) (
    initialSupply[i]
    + sum(j in FACILITIES)(ship[j,i])
    - sum(j in FACILITIES)(ship[i,j])
    = requiredSupply[i]
  );

% Disallow self-shipping (no shipments from a facility to itself)
constraint
  forall(i in FACILITIES) (
    ship[i,i] = 0
  );

% Define total transportation cost from shipment decisions and cost matrix
constraint
  totalCost =
    sum(i in FACILITIES, j in FACILITIES) (
      ship[i,j] * cost[i,j]
    );


% Objective
solve minimize totalCost;