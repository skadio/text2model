% Parameters
int: cap_regular = 20;
int: gas_regular = 10;
int: cap_speed = 30;
int: gas_speed = 20;

int: max_regular_trips = 20;
int: demand = 1000;

% Variables
var 0..max_regular_trips: r;            % regular boat trips
var 0..(demand div cap_speed + 1): s;   % speed boat trips (upper bound sufficient)

% Constraints
constraint cap_regular * r + cap_speed * s >= demand;

constraint r <= max_regular_trips;

% at least 50% of trips are speed: s >= r
constraint s >= r;

% Objective
solve minimize gas_regular * r + gas_speed * s;