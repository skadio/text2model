% Parameters
int: P; % Number of power plants
int: C; % Number of cities
array[1..P] of int: Supply; % Electricity supply capacity of power plant p
array[1..C] of int: Demand; % Electricity demand of city c
array[1..P, 1..C] of int: TransmissionCosts; % Transmission cost from power plant p to city c

% Variables
array[1..P, 1..C] of var 0..max(Supply): Electricity; % Electricity sent from power plant p to city c

% Constraints
constraint forall(p in 1..P)(sum(c in 1..C)(Electricity[p,c]) <= Supply[p]); % Supply constraint
constraint forall(c in 1..C)(sum(p in 1..P)(Electricity[p,c]) = Demand[c]); % Demand constraint

% Objective
var int: TotalCost = sum(p in 1..P, c in 1..C)(Electricity[p,c]*TransmissionCosts[p,c]);
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Electricity: "] ++ [show(Electricity[p,c]) | p in 1..P, c in 1..C];