% Parameters
% Investment types: 1=Residential (X), 2=Commercial (Y), 3=Industrial (Z)
int: nTypes = 3;
set of int: TYPES = 1..nTypes;

% Budget limit in units
int: maxTotalUnits = 500;

% Minimum and maximum investment per type (units)
array[TYPES] of int: minUnits = [100, 50, 30];
array[TYPES] of int: maxUnits = [300, 200, 150];

% Cost per unit ($ per unit) for each type
array[TYPES] of int: costPerUnit = [100, 200, 150];


% Variables
% Units invested in each property type (integer units)
array[TYPES] of var int: investUnits;

% Total units invested across all types
var 0..maxTotalUnits: totalUnits;

% Total cost in dollars (upper bound uses the maximum unit cost)
var 0..(maxTotalUnits * max(costPerUnit)): totalCost;


% Constraints
% Investment bounds per property type (viability + diversification limits)
constraint
  forall(t in TYPES) (
    investUnits[t] >= minUnits[t] /\
    investUnits[t] <= maxUnits[t]
  );

% Total invested units equals the sum across types
constraint
  totalUnits = sum(t in TYPES)(investUnits[t]);

% Overall budget limit on total units invested
constraint
  totalUnits <= maxTotalUnits;

% Total cost computed from per-unit costs and invested units
constraint
  totalCost = sum(t in TYPES)(costPerUnit[t] * investUnits[t]);


% Objective
solve minimize totalCost;