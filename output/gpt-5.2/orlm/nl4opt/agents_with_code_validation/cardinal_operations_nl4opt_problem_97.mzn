% Parameters
int: truck_capacity = 50;          % packages per truck trip
int: car_capacity   = 30;          % packages per car trip

int: truck_gas = 20;               % liters per truck trip
int: car_gas   = 15;               % liters per car trip

int: max_truck_trips = 5;          % maximum number of truck trips
int: min_packages    = 500;        % minimum number of packages to transport

float: min_car_share = 0.30;       % at least this fraction of all trips must be by car

% Convert car-share requirement to integer percentage to avoid float coercions
int: car_share_pct = round(100.0 * min_car_share);  % e.g., 30


% Variables
var 0..max_truck_trips: truck_trips;  % number of truck trips

% Upper bound derived from meeting min_packages using only cars:
% ceil(min_packages / car_capacity) = ceil(500/30) = 17
var 0..17: car_trips;                 % number of car trips

var 0..(truck_gas*max_truck_trips + car_gas*17): total_gas; % total liters of gas consumed


% Constraints
% Gas accounting: total gas equals gas per trip times number of trips
constraint
  total_gas = truck_gas * truck_trips + car_gas * car_trips;

% Package demand: transport at least the required number of packages
constraint
  truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

% Minimum car share:
% car_trips / (truck_trips + car_trips) >= min_car_share
% Implemented as: (100 - p) * car_trips >= p * truck_trips, where p=car_share_pct
constraint
  (100 - car_share_pct) * car_trips >= car_share_pct * truck_trips;


% Objective
solve minimize total_gas;