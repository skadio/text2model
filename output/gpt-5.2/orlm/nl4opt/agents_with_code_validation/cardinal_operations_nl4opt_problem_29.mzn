% Parameters
int: items_per_top = 50;                 % items washed per day by one top-loading machine
int: items_per_front = 75;               % items washed per day by one front-loading machine
int: kwh_per_top = 85;                   % kWh consumed per day by one top-loading machine
int: kwh_per_front = 100;                % kWh consumed per day by one front-loading machine

int: min_items_per_day = 5000;           % minimum required items washed per day
int: max_kwh_per_day = 7000;             % available kWh per day

float: max_top_fraction = 0.40;          % at most this fraction of machines can be top-loading
int: min_front_machines = 10;            % at least this many front-loading machines

% Safe upper bound on number of machines needed
int: max_machines = 100;

% Variables
var 0..max_machines: num_top;            % number of top-loading machines to buy
var 0..max_machines: num_front;          % number of front-loading machines to buy
var 0..2*max_machines: total_machines;   % total machines bought (objective)

% Constraints
% Total machines definition
constraint
  total_machines = num_top + num_front;

% Daily washing capacity must meet or exceed required minimum
constraint
  items_per_top * num_top + items_per_front * num_front >= min_items_per_day;

% Daily energy consumption must not exceed available kWh
constraint
  kwh_per_top * num_top + kwh_per_front * num_front <= max_kwh_per_day;

% Top-loading machines fraction limit (integer-safe form)
constraint
  100 * num_top <= round(max_top_fraction * 100.0) * total_machines;

% Minimum number of front-loading machines
constraint
  num_front >= min_front_machines;

% Objective
solve minimize total_machines;