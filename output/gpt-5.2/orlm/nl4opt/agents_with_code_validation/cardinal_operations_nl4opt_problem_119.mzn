% Parameters
int: regular_capacity = 20;        % pieces of mail per regular boat trip
int: speed_capacity   = 30;        % pieces of mail per speed boat trip
int: regular_gas      = 10;        % liters of gas per regular boat trip
int: speed_gas        = 20;        % liters of gas per speed boat trip

int: max_regular_trips = 20;       % maximum number of regular boat trips allowed
int: total_mail        = 1000;     % total pieces of mail to deliver
int: min_speed_percent = 50;       % at least this percent of trips must be speed trips

% Variables
var 0..max_regular_trips: regular_trips;     % number of regular boat trips
var 0..total_mail:        speed_trips;       % number of speed boat trips (broad upper bound)
var 0..(regular_gas*max_regular_trips + speed_gas*total_mail): total_gas; % total gas used

% Constraints
% Deliver at least the required amount of mail
constraint
  regular_capacity * regular_trips + speed_capacity * speed_trips >= total_mail;

% Regular trips cannot exceed the given maximum (redundant with domain, kept for clarity)
constraint
  regular_trips <= max_regular_trips;

% At least min_speed_percent% of all trips are speed trips (avoid division via cross-multiplication)
constraint
  100 * speed_trips >= min_speed_percent * (regular_trips + speed_trips);

% Total gas accounting
constraint
  total_gas = regular_gas * regular_trips + speed_gas * speed_trips;

% Objective
solve minimize total_gas;