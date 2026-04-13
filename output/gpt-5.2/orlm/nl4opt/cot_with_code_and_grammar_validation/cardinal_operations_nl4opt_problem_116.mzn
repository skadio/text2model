% Parameters
int: cap_tube = 50;
int: cost_tube = 500;

int: cap_tanker = 30;
int: cost_tanker = 200;

int: demand = 1000;
int: budget = 3750;

% Variables
var 0..ceil(demand div cap_tube + 1): x_tube;     % number of tube trailer trips
var 0..ceil(demand div cap_tanker + 1): x_tanker; % number of tanker trips

var 0..(ceil(demand div min(cap_tube, cap_tanker)) + 10): total_trips;

% Constraints
constraint total_trips = x_tube + x_tanker;

constraint cap_tube * x_tube + cap_tanker * x_tanker >= demand;
constraint cost_tube * x_tube + cost_tanker * x_tanker <= budget;

constraint x_tube < x_tanker;

% Objective
solve minimize total_trips;