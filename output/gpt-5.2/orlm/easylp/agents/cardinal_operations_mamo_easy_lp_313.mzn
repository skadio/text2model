% Parameters
int: total_resource_points = 1000;         % Total available resource points
int: resource_per_tank     = 5;            % Resource points per Tank
int: resource_per_aircraft = 3;            % Resource points per Aircraft
int: resource_per_submarine= 2;            % Resource points per Submarine

int: min_strength = 200;                   % Minimum required combined strength
int: strength_tank_coeff      = 2;         % Strength contribution coefficient for Tanks
int: strength_aircraft_coeff  = 4;         % Strength contribution coefficient for Aircrafts
int: strength_submarine_coeff = 1;         % Strength contribution coefficient for Submarines

int: diff_target = 50;                     % Tanks - (Aircrafts + Submarines) must equal this

int: cost_per_tank      = 30;              % Cost per Tank (dollars)
int: cost_per_aircraft  = 20;              % Cost per Aircraft (dollars)
int: cost_per_submarine = 10;              % Cost per Submarine (dollars)

% Upper bounds derived from resource limit (integer division)
int: max_tanks      = total_resource_points div resource_per_tank;
int: max_aircrafts  = total_resource_points div resource_per_aircraft;
int: max_submarines = total_resource_points div resource_per_submarine;

% Variables
var 0..max_tanks: tanks;                   % Number of Tanks (integer, non-negative)
var 0..max_aircrafts: aircrafts;           % Number of Aircrafts (integer, non-negative)
var 0..max_submarines: submarines;         % Number of Submarines (integer, non-negative)

% Total operational cost (dollars), bounded by max possible spend under variable bounds
var 0..(cost_per_tank*max_tanks
      + cost_per_aircraft*max_aircrafts
      + cost_per_submarine*max_submarines): total_cost;

% Constraints

%--- Resource budget: total resource points used cannot exceed the available limit
constraint
  resource_per_tank * tanks
+ resource_per_aircraft * aircrafts
+ resource_per_submarine * submarines
<= total_resource_points;

%--- Minimum required combined strength
constraint
  strength_tank_coeff * tanks
+ strength_aircraft_coeff * aircrafts
+ strength_submarine_coeff * submarines
>= min_strength;

%--- Exact difference constraint: Tanks - (Aircrafts + Submarines) = target
constraint
  tanks - (aircrafts + submarines) = diff_target;

%--- Define total operational cost from unit counts and per-unit costs
constraint
  total_cost =
    cost_per_tank * tanks
  + cost_per_aircraft * aircrafts
  + cost_per_submarine * submarines;

% Objective
solve minimize total_cost;

output [
  "tanks=", show(tanks), "\n",
  "aircrafts=", show(aircrafts), "\n",
  "submarines=", show(submarines), "\n",
  "total_cost=", show(total_cost), "\n"
];