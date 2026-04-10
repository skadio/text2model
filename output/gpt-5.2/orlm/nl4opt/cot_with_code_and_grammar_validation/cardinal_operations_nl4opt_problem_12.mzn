% Parameters
int: van_capacity = 6;
int: car_capacity = 3;
int: min_voters = 200;
int: van_percent_max = 30;

% Variables
var 0..ceil(min_voters / van_capacity): vans;
var 0..ceil(min_voters / car_capacity): cars;

% Constraints
constraint van_capacity * vans + car_capacity * cars >= min_voters;

% At most 30% of vehicles are vans: vans/(vans+cars) <= 0.30
% Equivalent (avoids division): 100*vans <= 30*(vans+cars)
constraint 100 * vans <= van_percent_max * (vans + cars);

% Objective
solve minimize cars;