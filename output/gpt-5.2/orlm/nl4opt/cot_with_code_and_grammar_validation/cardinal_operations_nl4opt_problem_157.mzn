% Parameters
int: truck_capacity = 1000;
int: van_capacity = 500;
int: truck_cost = 300;
int: van_cost = 100;

int: min_patties = 50000;
int: budget = 12500;

% Variables
var 0..(budget div truck_cost): trucks;
var 0..(budget div van_cost): vans;

var 0..(budget div 100): total_trips;

% Constraints
constraint total_trips = trucks + vans;

constraint trucks <= vans;

constraint truck_capacity * trucks + van_capacity * vans >= min_patties;

constraint truck_cost * trucks + van_cost * vans <= budget;

% Objective
solve minimize total_trips;