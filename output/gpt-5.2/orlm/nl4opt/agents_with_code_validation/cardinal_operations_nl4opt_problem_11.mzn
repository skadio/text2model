% Parameters
int: bike_capacity = 3;                  % People per bike
int: car_capacity  = 5;                  % People per car
int: min_people    = 500;                % Minimum people to transport
float: max_car_frac = 0.40;              % Max fraction of vehicles that can be cars

% Variables
% Upper bounds: using only that vehicle type to reach min_people
var 0..ceil(min_people / bike_capacity): bikes;  % Number of bikes used
var 0..ceil(min_people / car_capacity):  cars;   % Number of cars used

% Constraints

% Transport capacity constraint: total seats provided must cover at least min_people
constraint
  bike_capacity * bikes + car_capacity * cars >= min_people;

% Fleet composition constraint: at most max_car_frac of all vehicles can be cars
% cars <= max_car_frac * (bikes + cars)
% Reformulated to avoid float*var by using float arithmetic with int2float:
constraint
  (1.0 - max_car_frac) * int2float(cars) <= max_car_frac * int2float(bikes);

% Objective
solve minimize bikes;