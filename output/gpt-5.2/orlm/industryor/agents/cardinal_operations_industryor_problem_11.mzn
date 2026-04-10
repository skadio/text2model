% Parameters
int: nTypes = 6;                           % number of container types (sorted by increasing volume)
set of int: TYPES = 1..nTypes;             % index set for container types

array[TYPES] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];     % volume (cm^3) by type
array[TYPES] of int: demand = [500, 550, 700, 900, 400, 300];           % market demand (units) by type
array[TYPES] of int: unitCost = [5, 8, 10, 12, 16, 18];                 % variable cost (Yuan/unit) by type

int: setupCost = 1200;                     % fixed setup cost per activated type (Yuan)

% Variables
array[TYPES] of var 0..sum(demand): produce;          % quantity produced of each type
array[TYPES] of var bool: activate;                   % true if equipment for type i is activated

% Allocation: ship[i,j] = units of type i used to satisfy demand of type j (allowed only if i >= j)
array[TYPES, TYPES] of var 0..sum(demand): ship;      % substitution/assignment quantities

% Constraints

%-------------------------------
% Activation logic: activate[i] iff produce[i] > 0
%-------------------------------
constraint
  forall(i in TYPES) (
    (produce[i] > 0) <-> activate[i]
  );

%-------------------------------
% Feasible substitution structure:
% only larger/equal volume types can satisfy smaller demand (i >= j).
% Enforce ship[i,j] = 0 for forbidden pairs (i < j).
%-------------------------------
constraint
  forall(i, j in TYPES where i < j) (
    ship[i,j] = 0
  );

%-------------------------------
% Demand satisfaction: each demand j must be fully met by shipments from eligible types i >= j
%-------------------------------
constraint
  forall(j in TYPES) (
    sum(i in TYPES where i >= j) (ship[i,j]) = demand[j]
  );

%-------------------------------
% Production balance: all units produced of type i must be allocated to some demand j <= i
%-------------------------------
constraint
  forall(i in TYPES) (
    sum(j in TYPES where j <= i) (ship[i,j]) = produce[i]
  );

% Objective
solve minimize
  sum(i in TYPES) (unitCost[i] * produce[i])
  + setupCost * sum(i in TYPES) (bool2int(activate[i]));