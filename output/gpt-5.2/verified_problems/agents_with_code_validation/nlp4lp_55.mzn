% Parameters
int: P; % Number of power plants
int: C; % Number of cities

set of int: PLANTS = 1..P; % Index set of power plants
set of int: CITIES = 1..C; % Index set of cities

array[PLANTS] of int: Supply; % Supply capacity of each power plant p
array[CITIES] of int: Demand; % Demand of each city c

array[PLANTS, CITIES] of int: TransmissionCosts; % Cost to transmit from plant p to city c


% Variables
% Flow[p,c] = electricity sent from plant p to city c (non-negative)
array[PLANTS, CITIES] of var 0..max(Supply): Flow;


% Constraints
% Plant capacity constraints: total outgoing flow from each plant cannot exceed its supply
constraint
  forall(p in PLANTS) (
    sum(c in CITIES)(Flow[p, c]) <= Supply[p]
  );

% City demand constraints: total incoming flow to each city must meet its demand
constraint
  forall(c in CITIES) (
    sum(p in PLANTS)(Flow[p, c]) = Demand[c]
  );


% Objective
% Minimize total transmission cost
solve minimize sum(p in PLANTS, c in CITIES)(TransmissionCosts[p, c] * Flow[p, c]);