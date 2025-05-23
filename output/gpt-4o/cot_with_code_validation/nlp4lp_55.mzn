% Parameters
int: P;                         % Number of power plants
int: C;                         % Number of cities
set of int: PLANTS = 1..P;
set of int: CITIES = 1..C;

array[PLANTS] of int: Supply;   % Capacity of each power plant
array[CITIES] of int: Demand;   % Peak demand of each city
array[PLANTS, CITIES] of int: TransmissionCosts;   % Cost matrix

int: totalDemand = sum(c in CITIES)(Demand[c]);

% Variables
array[PLANTS, CITIES] of var 0..totalDemand: Flow;    % Electricity sent from plant p to city c

% Constraints
% 1. Respect supply capacity of each power plant
constraint
    forall(p in PLANTS)(
        sum(c in CITIES)(Flow[p, c]) <= Supply[p]
    );

% 2. Meet the demand of each city exactly
constraint
    forall(c in CITIES)(
        sum(p in PLANTS)(Flow[p, c]) == Demand[c]
    );

% Objective
solve minimize
    sum(p in PLANTS, c in CITIES)(Flow[p, c] * TransmissionCosts[p, c]);