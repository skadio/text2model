% Parameters
int: limo_capacity = 12;              % People per limousine
int: bus_capacity  = 18;              % People per bus
int: min_people    = 400;             % Minimum number of people to transport
int: min_limo_pct  = 70;              % Minimum percent of vehicles that are limousines

% Helper bounds (safe upper bounds for search)
int: max_limos = ceil(int2float(min_people) / int2float(limo_capacity)); % all by limos
int: max_buses = ceil(int2float(min_people) / int2float(bus_capacity));  % all by buses

% Variables
var 0..max_limos: num_limos;          % Number of limousines used
var 0..max_buses: num_buses;          % Number of buses used

% Constraints

% Capacity requirement: transport at least the minimum number of people
constraint
  limo_capacity * num_limos + bus_capacity * num_buses >= min_people;

% Fleet composition requirement: at least min_limo_pct% of vehicles are limousines
% Cross-multiplied to keep integer arithmetic:
% num_limos / (num_limos + num_buses) >= min_limo_pct / 100
constraint
  100 * num_limos >= min_limo_pct * (num_limos + num_buses);

% Non-triviality: must use at least one vehicle (redundant but explicit)
constraint
  num_limos + num_buses >= 1;

% Objective
solve minimize (num_limos + num_buses);