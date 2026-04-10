% Parameters
int: nCities = 5;                         % Number of cities
set of int: CITIES = 1..nCities;          % City index set

array[CITIES] of int: initialSupply =     % Initial resource units at each city
  [221, 98, 337, 425, 250];

array[CITIES] of int: requiredDemand =    % Required resource units at each city
  [128, 317, 394, 108, 101];

array[CITIES, CITIES] of int: transportCost =  % Cost per unit transported from i to j
  [| 0, 20, 39,  4, 45
   | 1,  0,  8, 23, 44
   | 5, 46,  0, 36, 15
   | 3,  5, 10,  0, 27
   |37, 15,  7, 45,  0 |];

% Total supply/demand (used for bounds and feasibility checking)
int: totalSupply = sum(i in CITIES)(initialSupply[i]);
int: totalDemand = sum(i in CITIES)(requiredDemand[i]);

% Precompute max transport cost for a safe upper bound on totalCost
int: maxCost = max(i in CITIES, j in CITIES)(transportCost[i,j]);

% Variables
array[CITIES, CITIES] of var 0..totalSupply: flow;  % Units shipped from city i to city j
var 0..(totalSupply * maxCost): totalCost;          % Total transportation cost

% Constraints

%--------------------------
% Feasibility: total supply must cover total demand
%--------------------------
constraint totalSupply >= totalDemand;

%--------------------------
% No self-shipment (fix to 0 to avoid redundancy)
%--------------------------
constraint forall(i in CITIES) (
  flow[i,i] = 0
);

%--------------------------
% Supply limits: total shipped out of a city cannot exceed its initial supply
%--------------------------
constraint forall(i in CITIES) (
  sum(j in CITIES)(flow[i,j]) <= initialSupply[i]
);

%--------------------------
% Demand satisfaction (flow balance):
% initialSupply[i] - outflow[i] + inflow[i] >= requiredDemand[i]
%--------------------------
constraint forall(i in CITIES) (
  initialSupply[i]
  - sum(j in CITIES)(flow[i,j])
  + sum(j in CITIES)(flow[j,i])
  >= requiredDemand[i]
);

%--------------------------
% Total transportation cost definition
%--------------------------
constraint totalCost =
  sum(i in CITIES, j in CITIES)(flow[i,j] * transportCost[i,j]);

% Objective
solve minimize totalCost;