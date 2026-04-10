% Parameters
int: heli_capacity = 30;
int: heli_time = 40;
int: car_capacity = 20;
int: car_time = 30;

int: max_heli_trips = 5;
int: min_fish = 300;

int: pct_car_num = 60;   % at least 60% of trips by car
int: pct_car_den = 100;

% Variables
var 0..max_heli_trips: h;           % helicopter trips
var 0..1000: c;                     % car trips (upper bound set large enough)

var 0..100000: total_time;

% Constraints
constraint heli_capacity * h + car_capacity * c >= min_fish;

% c / (c + h) >= 0.6  ->  100*c >= 60*(c+h)
constraint pct_car_den * c >= pct_car_num * (c + h);

constraint total_time = heli_time * h + car_time * c;

% Objective
solve minimize total_time;