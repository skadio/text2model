% Parameters
% Deployment limits
int: max_tanks = 20;
int: max_aircrafts = 15;

% Strength constraints
int: strength_tank_coeff = 3;
int: strength_aircraft_coeff = 2;
int: min_combined_strength = 10;

int: cap_tank_coeff = 4;
int: cap_aircraft_coeff = 1;
int: max_cap_value = 30;

% Support point costs
int: support_per_tank = 5;
int: support_per_aircraft = 7;


% Variables
var 0..max_tanks: tanks;                  % number of tanks to deploy
var 0..max_aircrafts: aircrafts;          % number of aircrafts to deploy

% total support points used (upper bound from max possible deployment)
var 0..(support_per_tank*max_tanks + support_per_aircraft*max_aircrafts): total_support;


% Constraints
% --- Strength requirement: ensure minimum combined strength is achieved ---
constraint
  strength_tank_coeff * tanks + strength_aircraft_coeff * aircrafts >= min_combined_strength;

% --- Capacity/operational cap: limit weighted deployment to not exceed maximum ---
constraint
  cap_tank_coeff * tanks + cap_aircraft_coeff * aircrafts <= max_cap_value;

% --- Total support accounting: define total support as linear cost of units deployed ---
constraint
  total_support = support_per_tank * tanks + support_per_aircraft * aircrafts;


% Objective
solve minimize total_support;