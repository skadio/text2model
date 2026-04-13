% Parameters
int: P; % number of power plants
int: C; % number of cities

set of int: PLANTS = 1..P;  % index set for power plants
set of int: CITIES = 1..C;  % index set for cities

array[PLANTS] of int: Supply; % supply capacity of each power plant
array[CITIES] of int: Demand; % demand required by each city

array[PLANTS, CITIES] of int: TransmissionCosts; % unit transmission cost from plant p to city c

% Variables
array[PLANTS, CITIES] of var int: Send; % electricity sent from plant p to city c (units)

% Constraints
% --- Nonnegativity bounds for all shipments ---
constraint forall(p in PLANTS, c in CITIES) (Send[p,c] >= 0);

% --- Plant capacity constraints: total sent from each plant cannot exceed its supply ---
constraint
  forall(p in PLANTS) (
    sum(c in CITIES)(Send[p,c]) <= Supply[p]
  );

% --- City demand constraints: total received by each city must meet its demand (at peak) ---
constraint
  forall(c in CITIES) (
    sum(p in PLANTS)(Send[p,c]) = Demand[c]
  );

% Objective
solve minimize sum(p in PLANTS, c in CITIES)(TransmissionCosts[p,c] * Send[p,c]);