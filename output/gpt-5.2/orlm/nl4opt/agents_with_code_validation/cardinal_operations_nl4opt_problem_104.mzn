% Parameters
int: limo_capacity = 12;          % People per limousine
int: bus_capacity  = 18;          % People per bus
int: min_people    = 400;         % Minimum number of people to transport
float: min_limo_ratio = 0.70;     % At least this fraction of vehicles are limousines

% A safe upper bound on vehicles: worst case uses only limousines (smallest capacity)
int: max_vehicles = ceil(int2float(min_people) / int2float(limo_capacity));

% Variables
var 0..max_vehicles: num_limos;   % Number of limousines used
var 0..max_vehicles: num_buses;   % Number of buses used

% Constraints

% Capacity constraint: transport at least the minimum required people
constraint
  limo_capacity * num_limos + bus_capacity * num_buses >= min_people;

% Fleet composition constraint: at least min_limo_ratio of all vehicles are limousines
% num_limos / (num_limos + num_buses) >= min_limo_ratio
% Rewritten to avoid division:
constraint
  int2float(num_limos) >= min_limo_ratio * int2float(num_limos + num_buses);

% Objective
solve minimize (num_limos + num_buses);