% Parameters (with values embedded)
int: truck_capacity = 1000;
int: van_capacity   = 500;
int: truck_cost     = 300;
int: van_cost       = 100;

int: min_patties = 50000;
int: budget      = 12500;

% Upper bounds from budget (tight and integer)
int: max_trucks = budget div truck_cost; % 41
int: max_vans   = budget div van_cost;   % 125

% Variables
var 0..max_trucks: trucks;
var 0..max_vans: vans;
var 0..(max_trucks + max_vans): total_trips;

% Constraints
constraint total_trips = trucks + vans;

% Capacity requirement
constraint truck_capacity * trucks + van_capacity * vans >= min_patties;

% Budget constraint
constraint truck_cost * trucks + van_cost * vans <= budget;

% City maneuverability constraint
constraint trucks <= vans;

% Objective
solve minimize total_trips;