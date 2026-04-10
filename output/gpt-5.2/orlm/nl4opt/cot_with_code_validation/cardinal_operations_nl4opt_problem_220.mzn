% Parameters
int: min_people = 550;

int: cap_kayak = 4;
int: cap_motor = 5;

int: time_kayak = 5;   % minutes per trip
int: time_motor = 3;   % minutes per trip

int: max_motor_trips = 25;

% At least 75% of trips are by kayak:
% kayak_trips / (kayak_trips + motor_trips) >= 0.75
% <=> 4*kayak_trips >= 3*motor_trips
int: kayak_ratio_lhs = 4;
int: kayak_ratio_rhs = 3;

% Upper bounds (safe)
int: ub_kayak = 200;  % 200*4 = 800 people, sufficient
int: ub_motor = max_motor_trips;

% Variables
var 0..ub_kayak: kayak_trips;
var 0..ub_motor: motor_trips;

var 0..(time_kayak*ub_kayak + time_motor*ub_motor): total_time;

% Constraints
constraint cap_kayak * kayak_trips + cap_motor * motor_trips >= min_people;

constraint motor_trips <= max_motor_trips;

constraint kayak_ratio_lhs * kayak_trips >= kayak_ratio_rhs * motor_trips;

constraint total_time = time_kayak * kayak_trips + time_motor * motor_trips;

% Objective
solve minimize total_time;