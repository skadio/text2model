% Parameters
int: max_total_weight = 10000;        % total transport capacity (tons)
int: tank_weight      = 3;            % weight per tank (tons)
int: aircraft_weight  = 4;            % weight per aircraft (tons)

int: min_firepower_score    = 2000;   % minimum required combined firepower score
int: tank_firepower_coeff   = 2;      % coefficient for tanks in firepower score
int: aircraft_firepower_coeff = 1;    % coefficient for aircraft in firepower score

int: tank_cost     = 5000;            % cost per tank ($)
int: aircraft_cost = 3000;            % cost per aircraft ($)

% Variables
var 0..(max_total_weight div tank_weight): tanks;           % number of tanks (integer)
var 0..(max_total_weight div aircraft_weight): aircraft;    % number of aircraft (integer)
var 0..(tank_cost * (max_total_weight div tank_weight)
      + aircraft_cost * (max_total_weight div aircraft_weight)): total_cost; % total cost ($)

% Constraints
% Weight capacity constraint: total transported weight must not exceed capacity
constraint
  tank_weight * tanks + aircraft_weight * aircraft <= max_total_weight;

% Minimum firepower constraint: ensure strategic firepower requirement is met
constraint
  tank_firepower_coeff * tanks + aircraft_firepower_coeff * aircraft >= min_firepower_score;

% Total cost definition: link total_cost variable to decision variables
constraint
  total_cost = tank_cost * tanks + aircraft_cost * aircraft;

% Objective
solve minimize total_cost;