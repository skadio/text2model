% Parameters
int: regular_capacity = 20;
int: regular_gas = 10;
int: speed_capacity = 30;
int: speed_gas = 20;

int: max_regular_trips = 20;
int: demand = 1000;

% Variables
var 0..max_regular_trips: r;                 % number of regular boat trips
var 0..(demand div speed_capacity + 100): s; % number of speed boat trips (safe upper bound)

var 0..(regular_gas * max_regular_trips + speed_gas * (demand div speed_capacity + 100)): total_gas;

% Constraints
constraint regular_capacity * r + speed_capacity * s >= demand;

% At least 50% of trips are speed: s >= 0.5*(r+s)  <=>  s >= r
constraint s >= r;

constraint total_gas = regular_gas * r + speed_gas * s;

% Objective
solve minimize total_gas;