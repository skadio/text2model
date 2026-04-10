% Parameters
int: cap_truck = 4;
int: cap_van   = 3;
int: demand    = 15;

int: road_truck_coef = 2;
int: road_van_coef   = 1;
int: road_limit      = 30;

int: cost_truck = 6;
int: cost_van   = 7;

% Variables
var 0..road_limit: trucks;
var 0..road_limit: vans;

var 0..(cost_truck*road_limit + cost_van*road_limit): total_cost;

% Constraints
constraint cap_truck * trucks + cap_van * vans >= demand;
constraint road_truck_coef * trucks + road_van_coef * vans <= road_limit;

constraint total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;