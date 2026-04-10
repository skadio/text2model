% Parameters
int: max_total_weight = 10000;          % Maximum supported total weight (tons)
int: tank_weight      = 3;              % Weight per tank (tons)
int: aircraft_weight  = 4;              % Weight per aircraft (tons)

int: min_firepower_score = 2000;        % Minimum required combined firepower score
int: tank_firepower_mult = 2;           % Firepower multiplier per tank
int: aircraft_firepower_mult = 1;       % Firepower multiplier per aircraft

int: tank_cost     = 5000;              % Cost per tank ($)
int: aircraft_cost = 3000;              % Cost per aircraft ($)

% Variables
var 0..(max_total_weight div tank_weight): tanks;           % Number of tanks (integer, bounded by weight)
var 0..(max_total_weight div aircraft_weight): aircraft;    % Number of aircraft (integer, bounded by weight)

var 0..(tank_cost * (max_total_weight div tank_weight)
      + aircraft_cost * (max_total_weight div aircraft_weight)): total_cost; % Total cost ($), bounded

% Constraints
% Weight capacity constraint: total transported weight must not exceed maximum
constraint
  tank_weight * tanks + aircraft_weight * aircraft <= max_total_weight;

% Firepower requirement constraint: combined firepower must meet or exceed minimum
constraint
  tank_firepower_mult * tanks + aircraft_firepower_mult * aircraft >= min_firepower_score;

% Total cost definition constraint: link total_cost to decision variables
constraint
  total_cost = tank_cost * tanks + aircraft_cost * aircraft;

% Objective
solve minimize total_cost;