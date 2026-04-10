% Parameters
int: max_shifts = 40;
int: max_energy = 230;
int: min_orders = 320;
int: min_scooter_shifts = 5;

int: bike_orders = 10;
int: bike_energy = 5;
int: bike_tips = 50;

int: scooter_orders = 7;
int: scooter_energy = 6;
int: scooter_tips = 43;

% Variables
var 0..max_shifts: bike_shifts;
var 0..max_shifts: scooter_shifts;

var 0..(bike_orders * max_shifts + scooter_orders * max_shifts): total_orders;
var 0..(bike_energy * max_shifts + scooter_energy * max_shifts): total_energy;
var 0..(bike_tips * max_shifts + scooter_tips * max_shifts): total_tips;

% Constraints
constraint bike_shifts + scooter_shifts <= max_shifts;
constraint scooter_shifts >= min_scooter_shifts;

constraint total_orders = bike_orders * bike_shifts + scooter_orders * scooter_shifts;
constraint total_energy = bike_energy * bike_shifts + scooter_energy * scooter_shifts;
constraint total_tips = bike_tips * bike_shifts + scooter_tips * scooter_shifts;

constraint total_orders >= min_orders;
constraint total_energy <= max_energy;

% Objective
solve maximize total_tips;