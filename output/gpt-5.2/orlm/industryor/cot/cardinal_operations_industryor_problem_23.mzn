% Parameters (with values embedded)
int: demand = 1800;

int: poll_truck = 100;
int: poll_van = 50;
int: poll_moto = 10;
int: poll_ev = 0;

int: cap_truck = 100;
int: cap_van = 80;
int: cap_moto = 40;
int: cap_ev = 60;

int: max_pollution = 2000;
int: min_truck_trips = 10;

% Variables
var 0..1000: x_truck;
var 0..1000: x_van;
var 0..1000: x_moto;
var 0..1000: x_ev;

var 0..1: use_van;
var 0..1: use_ev;

var 0..max_pollution: total_pollution;

% Constraints
constraint x_truck >= min_truck_trips;

% Either vans or electric vehicles, but not both (can also use neither)
constraint use_van + use_ev <= 1;
constraint x_van <= 1000 * use_van;
constraint x_ev <= 1000 * use_ev;

% Demand satisfaction (deliver at least 1800 units)
constraint cap_truck * x_truck
         + cap_van * x_van
         + cap_moto * x_moto
         + cap_ev * x_ev >= demand;

% Pollution accounting and limit
constraint total_pollution =
           poll_truck * x_truck
         + poll_van * x_van
         + poll_moto * x_moto
         + poll_ev * x_ev;

constraint total_pollution <= max_pollution;

% Objective
solve minimize total_pollution;