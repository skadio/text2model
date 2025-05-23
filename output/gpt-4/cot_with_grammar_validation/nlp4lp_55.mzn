% Parameters
int: P; % Number of power plants
int: C; % Number of cities
array[1..P] of int: Supply; % Electricity supply capacity of power plant p
array[1..C] of int: Demand; % Electricity demand of city c
array[1..P, 1..C] of int: TransmissionCosts; % Transmission cost from power plant p to city c

% Variables
array[1..P, 1..C] of var 0..max(Supply): Electricity; % Electricity sent from power plant p to city c

% Constraints
constraint forall(p in 1..P)(sum(c in 1..C)(Electricity[p,c]) <= Supply[p]); % Each power plant cannot supply more than its capacity
constraint forall(c in 1..C)(sum(p in 1..P)(Electricity[p,c]) = Demand[c]); % Each city's demand must be met

% Objective
solve minimize sum(p in 1..P, c in 1..C)(Electricity[p,c]*TransmissionCosts[p,c]); % Minimize the total transmission cost