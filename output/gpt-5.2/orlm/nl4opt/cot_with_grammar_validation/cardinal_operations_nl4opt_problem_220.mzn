% Parameters
int: min_people = 550;

int: cap_kayak = 4;
int: cap_motor = 5;

int: time_kayak = 5;   % minutes per trip
int: time_motor = 3;   % minutes per trip

int: max_motor_trips = 25;

int: kayak_share_num = 3; % at least 75% kayak trips => 4*kayak >= 3*(kayak+motor)
int: kayak_share_den = 4;

% Variables
var 0..min_people: kayak_trips;
var 0..max_motor_trips: motor_trips;

var 0..(time_kayak*min_people + time_motor*max_motor_trips): total_time;

% Constraints
constraint cap_kayak * kayak_trips + cap_motor * motor_trips >= min_people;

% At least 75% of trips by kayak: kayak_trips / (kayak_trips + motor_trips) >= 3/4
constraint kayak_share_den * kayak_trips >= kayak_share_num * (kayak_trips + motor_trips);

constraint total_time = time_kayak * kayak_trips + time_motor * motor_trips;

% Objective
solve minimize total_time;