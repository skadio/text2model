% Parameters
int: cap_truck = 4;
int: cap_van = 3;
int: demand_min = 15;

int: restrict_truck_coeff = 2;
int: restrict_van_coeff = 1;
int: restrict_max = 30;

int: cost_truck = 6;
int: cost_van = 7;

% Variables
var 0..restrict_max: trucks;
var 0..restrict_max: vans;
var 0..(cost_truck*restrict_max + cost_van*restrict_max): total_cost;

% Constraints
constraint cap_truck * trucks + cap_van * vans >= demand_min;
constraint restrict_truck_coeff * trucks + restrict_van_coeff * vans <= restrict_max;

constraint total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;