% Parameters
int: heli_capacity = 30;
int: heli_time = 40;
int: car_capacity = 20;
int: car_time = 30;

int: max_heli_trips = 5;
int: min_fish = 300;

int: pct_car_num = 60;
int: pct_car_den = 100;

% Variables
var 0..max_heli_trips: heli_trips;
var 0..1000: car_trips;
var 0..100000: total_time;

% Constraints
constraint heli_capacity * heli_trips + car_capacity * car_trips >= min_fish;

constraint pct_car_den * car_trips >= pct_car_num * (car_trips + heli_trips);

constraint total_time = heli_time * heli_trips + car_time * car_trips;

% Objective
solve minimize total_time;