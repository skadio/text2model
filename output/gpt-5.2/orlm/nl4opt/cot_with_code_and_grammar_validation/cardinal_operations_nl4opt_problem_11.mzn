% Parameters
int: bike_capacity = 3;
int: car_capacity = 5;
int: min_people = 500;
float: max_car_fraction = 0.4;

% Variables
var 0..ceil(int2float(min_people) / int2float(bike_capacity)): bikes;
var 0..ceil(int2float(min_people) / int2float(car_capacity)): cars;
var 0..(ceil(int2float(min_people) / int2float(bike_capacity)) + ceil(int2float(min_people) / int2float(car_capacity))): total_vehicles;

% Constraints
constraint total_vehicles = bikes + cars;

constraint bike_capacity * bikes + car_capacity * cars >= min_people;

% cars <= 40% of all vehicles  <=> 5*cars <= 2*(bikes+cars)  <=> 3*cars <= 2*bikes
constraint 3 * cars <= 2 * bikes;

% Objective
solve minimize bikes;