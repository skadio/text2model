% Parameters
int: cap_truck = 4;
int: cap_van = 3;
int: demand = 15;

int: road_truck_coeff = 2;
int: road_van_coeff = 1;
int: road_limit = 30;

int: cost_truck = 6;
int: cost_van = 7;

% Variables
var 0..ceil(demand div cap_truck) + demand: trucks;
var 0..ceil(demand div cap_van) + demand: vans;
var 0..(cost_truck * (ceil(demand div cap_truck) + demand) + cost_van * (ceil(demand div cap_van) + demand)): total_cost;

% Constraints
constraint cap_truck * trucks + cap_van * vans >= demand;
constraint road_truck_coeff * trucks + road_van_coeff * vans <= road_limit;

constraint total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;