% Parameters
int: P; % Number of power plants
int: C; % Number of cities
array[1..P] of int: Supply; % Electricity supply capacity of each power plant
array[1..C] of int: Demand; % Electricity demand of each city
array[1..P, 1..C] of int: TransmissionCosts; % Transmission cost from each power plant to each city

% Variables
array[1..P, 1..C] of var 0..max(Supply)+max(Demand): electricity_sent; % Amount of electricity sent from each power plant to each city

% Constraints

% Constraint 1: The total electricity sent from each power plant should not exceed its supply capacity
constraint forall(p in 1..P) (
  sum(c in 1..C) (electricity_sent[p,c]) <= Supply[p]
);

% Constraint 2: The total electricity received by each city should meet its demand
constraint forall(c in 1..C) (
  sum(p in 1..P) (electricity_sent[p,c]) >= Demand[c]
);

% Constraint 3: The electricity sent from a power plant to a city should not exceed the demand of the city
constraint forall(p in 1..P, c in 1..C) (
  electricity_sent[p,c] <= Demand[c]
);

% Constraint 4: The electricity sent from a power plant to a city should not exceed the supply of the power plant
constraint forall(p in 1..P, c in 1..C) (
  electricity_sent[p,c] <= Supply[p]
);

% Objective
solve minimize sum(p in 1..P, c in 1..C) (electricity_sent[p,c] * TransmissionCosts[p,c]);