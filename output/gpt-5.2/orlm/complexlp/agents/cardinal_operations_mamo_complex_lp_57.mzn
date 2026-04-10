% Parameters
int: nCities = 6;                              % Number of cities
set of int: CITIES = 1..nCities;               % City index set

array[CITIES] of int: supply =                 % Available food in each city (tons)
  [255, 250, 314, 8, 385, 440];

array[CITIES] of int: demand =                 % Required food in each city (tons)
  [251, 200, 366, 114, 59, 287];

array[CITIES, CITIES] of int: cost =           % Transportation cost per ton from i -> j
  [|  0, 26, 39, 13, 37, 28
   | 36,  0, 48,  5, 22, 14
   | 38, 36,  0, 12, 45, 36
   | 32, 18, 47,  0,  7,  9
   | 18,  6, 12, 20,  0, 42
   |  4, 28, 42, 43,  7,  0 |];

% Variables
array[CITIES, CITIES] of var int: ship;        % ship[i,j] = tons shipped from city i to city j

% Constraints

% Non-negativity: shipments cannot be negative
constraint
  forall(i in CITIES, j in CITIES) (
    ship[i, j] >= 0
  );

% No self-shipment: do not ship from a city to itself
constraint
  forall(i in CITIES) (
    ship[i, i] = 0
  );

% Supply capacity: total shipped out of each city cannot exceed its available supply
constraint
  forall(i in CITIES) (
    sum(j in CITIES) (ship[i, j]) <= supply[i]
  );

% Demand satisfaction (flow balance):
% initial supply + inflow - outflow must be at least the demand for each city
constraint
  forall(j in CITIES) (
    supply[j] + sum(i in CITIES) (ship[i, j]) - sum(k in CITIES) (ship[j, k]) >= demand[j]
  );

% Objective
solve minimize sum(i in CITIES, j in CITIES) (cost[i, j] * ship[i, j]);