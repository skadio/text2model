% Parameters
int: regular_capacity = 20;          % pieces of mail per regular boat trip
int: regular_gas = 10;               % liters of gas per regular boat trip
int: speed_capacity = 30;            % pieces of mail per speed boat trip
int: speed_gas = 20;                 % liters of gas per speed boat trip

int: max_regular_trips = 20;         % maximum number of regular boat trips
int: required_mail = 1000;           % total pieces of mail to deliver
int: min_speed_trip_percent = 50;    % at least this percent of trips must be speed trips

% Variables
var 0..max_regular_trips: regular_trips;  % number of regular boat trips
var 0..required_mail: speed_trips;        % number of speed boat trips (safe upper bound)

var 0..(regular_gas * max_regular_trips + speed_gas * required_mail): total_gas; % total liters of gas used

% Constraints
% Link total_gas to the chosen numbers of trips
constraint
  total_gas = regular_gas * regular_trips + speed_gas * speed_trips;

% Ensure enough mail capacity is provided to deliver the required amount
constraint
  regular_capacity * regular_trips + speed_capacity * speed_trips >= required_mail;

% Enforce that at least min_speed_trip_percent of all trips are speed trips
% Cross-multiplied to avoid division:
constraint
  100 * speed_trips >= min_speed_trip_percent * (regular_trips + speed_trips);

% Redundant safety: at least one trip must be taken if mail is required
constraint
  regular_trips + speed_trips >= 1;

% Objective
solve minimize total_gas;