% Parameters
int: nFacilities = 7;                          % Number of healthcare facilities
set of int: FAC = 1..nFacilities;              % Facility index set

array[FAC] of int: initial_supply =            % Initial units at each facility
  [229, 345, 231, 164, 354, 437, 265];

array[FAC] of int: required_supply =           % Required units at each facility
  [158, 14, 326, 432, 207, 215, 233];

array[FAC, FAC] of int: transfer_cost =        % Cost per unit transferred i->j
  [|  0, 26,  8,  7, 34, 35, 34
   | 41,  0, 27, 31,  3, 33, 36
   | 20, 49,  0, 48, 21, 38, 42
   | 10, 35, 26,  0, 21, 33, 31
   | 21, 30, 24, 25,  0,  5,  8
   | 27, 34, 34, 26, 27,  0, 43
   | 38, 20, 11, 43, 49,  9,  0
  |];

int: total_supply = sum(f in FAC)(initial_supply[f]);
int: total_required = sum(f in FAC)(required_supply[f]);

int: maxShip = total_supply;                   % Safe upper bound on any single shipment

% Variables
array[FAC, FAC] of var 0..maxShip: ship;       % Units shipped from facility i to facility j
var 0..(maxShip * 50): total_cost;             % Total transportation cost (safe upper bound)

% Constraints
% ------------------------------------------------------------------
% Feasibility check: total supply must equal total required
% ------------------------------------------------------------------
constraint total_supply = total_required;

% ------------------------------------------------------------------
% No self-shipment: do not allow shipping from a facility to itself
% ------------------------------------------------------------------
constraint forall(f in FAC) (
  ship[f, f] = 0
);

% ------------------------------------------------------------------
% Flow balance at each facility:
% initial + incoming - outgoing = required
% ------------------------------------------------------------------
constraint forall(f in FAC) (
  initial_supply[f]
  + sum(i in FAC)(ship[i, f])
  - sum(j in FAC)(ship[f, j])
  = required_supply[f]
);

% ------------------------------------------------------------------
% Define total transportation cost from shipments and per-unit costs
% ------------------------------------------------------------------
constraint total_cost =
  sum(i in FAC, j in FAC)(ship[i, j] * transfer_cost[i, j]);

% Objective
solve minimize total_cost;