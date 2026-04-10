% Parameters
int: bike_capacity = 3;              % People per bike
int: car_capacity  = 5;              % People per car
int: min_people    = 500;            % Minimum people to transport
float: max_car_frac = 0.40;          % Maximum fraction of vehicles that can be cars

% Upper bound on total vehicles from "all cars" case (helps bound variables)
int: max_vehicles = ceil(int2float(min_people) / int2float(car_capacity));

% Variables
var 0..max_vehicles: bikes;          % Number of bikes to use
var 0..max_vehicles: cars;           % Number of cars to use

% Constraints

% Transport capacity constraint: total seats provided must cover at least min_people
constraint
  bike_capacity * bikes + car_capacity * cars >= min_people;

% Car fraction constraint: at most max_car_frac of all vehicles are cars
% Use cross-multiplication to avoid float-var multiplication:
% cars <= max_car_frac * (bikes + cars)  <=>  (1 - max_car_frac)*cars <= max_car_frac*bikes
constraint
  (1.0 - max_car_frac) * int2float(cars) <= max_car_frac * int2float(bikes);

% Non-triviality: ensure at least one vehicle is used
constraint
  bikes + cars >= 1;

% Objective
solve minimize bikes;