% Parameters (with values embedded)
int: truck_capacity_coeff = 4;
int: van_capacity_coeff   = 3;
int: min_required_capacity = 15;

int: road_truck_coeff = 2;
int: road_van_coeff   = 1;
int: max_road_limit   = 30;

int: cost_truck = 6;
int: cost_van   = 7;

% Upper bounds derived from constraints: 2*trucks + vans <= 30 => trucks <= 15, vans <= 30
int: max_trucks = max_road_limit div road_truck_coeff; % 15
int: max_vans   = max_road_limit;                      % 30

% Variables
var 0..max_trucks: trucks;
var 0..max_vans: vans;

var int: total_cost;

% Constraints
constraint truck_capacity_coeff * trucks + van_capacity_coeff * vans >= min_required_capacity;
constraint road_truck_coeff * trucks + road_van_coeff * vans <= max_road_limit;

constraint total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;