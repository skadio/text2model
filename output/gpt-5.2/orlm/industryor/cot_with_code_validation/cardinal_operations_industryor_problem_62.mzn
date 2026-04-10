% Parameters
int: demand = 1000;
int: max_pollution = 1000;
int: min_horse_trips = 8;

int: poll_horse = 80;
int: poll_bicycle = 0;
int: poll_handcart = 0;

int: cap_horse = 55;
int: cap_bicycle = 30;
int: cap_handcart = 40;

% Upper bounds (safe and tight enough for this model)
int: ub_horse = max_pollution div poll_horse; % 12
int: ub_bicycle = (demand div cap_bicycle) + 1; % 34
int: ub_handcart = (demand div cap_handcart) + 1; % 26

% Variables
var 0..ub_horse: horse_trips;
var 0..ub_bicycle: bicycle_trips;
var 0..ub_handcart: handcart_trips;

var bool: use_bicycle;
var bool: use_handcart;

var 0..max_pollution: total_pollution;
var 0..(cap_horse*ub_horse + cap_bicycle*ub_bicycle + cap_handcart*ub_handcart): total_produce;

% Constraints
constraint horse_trips >= min_horse_trips;

constraint use_bicycle + use_handcart = 1;

constraint bicycle_trips <= ub_bicycle * bool2int(use_bicycle);
constraint handcart_trips <= ub_handcart * bool2int(use_handcart);

constraint total_pollution =
  poll_horse * horse_trips + poll_bicycle * bicycle_trips + poll_handcart * handcart_trips;

constraint total_pollution <= max_pollution;

constraint total_produce =
  cap_horse * horse_trips + cap_bicycle * bicycle_trips + cap_handcart * handcart_trips;

constraint total_produce >= demand;

% Objective
solve minimize total_pollution;