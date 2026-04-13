% Parameters
int: nCities = 4;                               % number of cities
set of int: CITIES = 1..nCities;                % city index set

array[CITIES] of int: supply = [483, 265, 130, 361];   % initial vaccines at each city
array[CITIES] of int: demand = [346, 221, 217, 293];   % required vaccines at each city

% Transport cost per vaccine shipped from i -> j (0 on diagonal: no self-shipment)
array[CITIES, CITIES] of int: cost =
  [|  0,  2, 19, 13
   | 34,  0, 10, 48
   | 46, 22,  0, 46
   | 48, 15, 23,  0 |];

% Variables
array[CITIES, CITIES] of var int: ship;         % ship[i,j] = vaccines shipped from city i to city j
var int: total_cost;                             % total transportation cost

% Constraints
% Nonnegative shipments and no self-shipment
constraint forall(i,j in CITIES) (ship[i,j] >= 0);
constraint forall(i in CITIES) (ship[i,i] = 0);

% Supply capacity: total outgoing shipments from each city cannot exceed its supply
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(ship[i,j]) <= supply[i]
  );

% Demand satisfaction / flow balance: each city's final vaccines must meet or exceed demand
constraint
  forall(j in CITIES) (
    supply[j]
    + sum(i in CITIES)(ship[i,j])     % inflow to j
    - sum(k in CITIES)(ship[j,k])     % outflow from j
    >= demand[j]
  );

% Define total transportation cost from shipment decisions
constraint
  total_cost = sum(i,j in CITIES)(cost[i,j] * ship[i,j]);

% Objective
solve minimize total_cost;