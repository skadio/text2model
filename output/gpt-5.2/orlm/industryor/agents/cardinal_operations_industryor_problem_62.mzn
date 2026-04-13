% Parameters
int: demand = 1000;                 % minimum total units of produce to transport
int: pollution_cap = 1000;          % maximum allowed total pollution
int: min_horse_trips = 8;           % minimum number of horse trips required

int: poll_horse = 80;               % pollution per horse trip
int: poll_bicycle = 0;              % pollution per bicycle trip
int: poll_handcart = 0;             % pollution per handcart trip

int: cap_horse = 55;                % units carried per horse trip
int: cap_bicycle = 30;              % units carried per bicycle trip
int: cap_handcart = 40;             % units carried per handcart trip

% Safe upper bounds on number of trips (from pollution or demand limits)
int: max_horse_trips = pollution_cap div poll_horse;  % since poll_horse > 0
int: max_bicycle_trips = demand div cap_bicycle + 1;
int: max_handcart_trips = demand div cap_handcart + 1;

% Variables
var min_horse_trips..max_horse_trips: horse_trips;    % number of horse trips
var 0..max_bicycle_trips: bicycle_trips;              % number of bicycle trips
var 0..max_handcart_trips: handcart_trips;            % number of handcart trips

var bool: use_bicycle;                                % true if bicycle is chosen (vs handcart)

var 0..pollution_cap: total_pollution;                % total pollution from all trips
var 0..(cap_horse*max_horse_trips + cap_bicycle*max_bicycle_trips + cap_handcart*max_handcart_trips): total_transported;
                                                      % total transported produce

% Constraints

% Link the selection decision to which manual transport mode can be used
constraint
  if use_bicycle then
    handcart_trips = 0
  else
    bicycle_trips = 0
  endif;

% Define total pollution from trips
constraint
  total_pollution =
      poll_horse   * horse_trips
    + poll_bicycle * bicycle_trips
    + poll_handcart * handcart_trips;

% Enforce the pollution cap
constraint
  total_pollution <= pollution_cap;

% Define total transported produce from trips
constraint
  total_transported =
      cap_horse   * horse_trips
    + cap_bicycle * bicycle_trips
    + cap_handcart * handcart_trips;

% Meet the demand requirement
constraint
  total_transported >= demand;

% Objective
solve minimize total_pollution;