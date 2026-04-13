% Parameters
int: nCities = 4;                                    % Number of cities
set of int: CITIES = 1..nCities;                     % City index set

array[CITIES] of int: supply = [483, 265, 130, 361]; % Initial vaccines available in each city
array[CITIES] of int: demand = [346, 221, 217, 293]; % Vaccines required in each city

% Transport cost per vaccine moved from city i to city j (0 on diagonal = no self-transport)
array[CITIES, CITIES] of int: cost =
  [|  0,  2, 19, 13
   | 34,  0, 10, 48
   | 46, 22,  0, 46
   | 48, 15, 23,  0 |];

% Useful bounds
int: totalSupply = sum(i in CITIES)(supply[i]);      % Total vaccines available
int: totalDemand = sum(i in CITIES)(demand[i]);      % Total vaccines required
int: maxCost = max(i,j in CITIES)(cost[i,j]);        % Maximum unit transport cost (incl. 0 diagonal)


% Variables
% x[i,j] = number of vaccines transported from city i to city j
array[CITIES, CITIES] of var 0..totalSupply: x;

% totalCost = total transportation cost
var 0..(maxCost * totalSupply): totalCost;


% Constraints

% Feasibility check: total supply must cover total demand
constraint totalSupply >= totalDemand;

% No self-transport
constraint forall(i in CITIES)(x[i,i] = 0);

% Outgoing shipments limited by each city's available supply
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

% Demand satisfaction via flow balance:
% (initial supply) + (incoming) - (outgoing) >= demand for each city
constraint forall(i in CITIES)(
  supply[i] + sum(j in CITIES)(x[j,i]) - sum(j in CITIES)(x[i,j]) >= demand[i]
);

% Total transportation cost definition
constraint totalCost =
  sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);


% Objective
solve minimize totalCost;