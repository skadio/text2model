include "globals.mzn";

% Number of power plants
int: P;

% Number of cities
int: C;

% Electricity supply capacity of each power plant
array[1..P] of int: Supply;

% Electricity demand of each city
array[1..C] of int: Demand;

% Transmission cost from each power plant to each city
array[1..P, 1..C] of int: TransmissionCosts;

% Decision variable: amount of electricity each power plant sends to each city
array[1..P, 1..C] of var 0..max(Supply): Electricity;

% Objective: minimize total transmission cost
var int: TotalCost = sum(p in 1..P, c in 1..C) (Electricity[p,c] * TransmissionCosts[p,c]);

% Constraint: each power plant cannot supply more than its capacity
constraint forall(p in 1..P) (sum(c in 1..C) (Electricity[p,c]) <= Supply[p]);

% Constraint: each city's demand must be met
constraint forall(c in 1..C) (sum(p in 1..P) (Electricity[p,c]) >= Demand[c]);

% Solve the problem
solve minimize TotalCost;

% Output the solution
output ["Total cost: ", show(TotalCost), "\n"] ++
["Electricity: "] ++ [show(Electricity[p,c]) | p in 1..P, c in 1..C];