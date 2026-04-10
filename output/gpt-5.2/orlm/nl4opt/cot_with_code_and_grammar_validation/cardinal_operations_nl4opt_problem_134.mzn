% Parameters
int: seat_sedan = 50;
int: seat_bus = 250;
int: poll_sedan = 10;
int: poll_bus = 40;

int: poll_max = 800;
int: demand_min = 4600;

% Variables
var 0..ceil(demand_min div seat_sedan): sedans;
var 0..ceil(demand_min div seat_bus): buses;
var 0..(ceil(demand_min div seat_sedan) + ceil(demand_min div seat_bus)): total_vehicles;

% Constraints
constraint
  seat_sedan * sedans + seat_bus * buses >= demand_min;

constraint
  poll_sedan * sedans + poll_bus * buses <= poll_max;

constraint
  total_vehicles = sedans + buses;

% Objective
solve minimize total_vehicles;