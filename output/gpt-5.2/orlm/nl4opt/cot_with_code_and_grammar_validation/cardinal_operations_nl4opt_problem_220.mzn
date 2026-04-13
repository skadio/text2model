% Parameters
int: min_people = 550;
int: cap_kayak = 4;
int: cap_motor = 5;
int: time_kayak = 5;
int: time_motor = 3;
int: max_motor_trips = 25;
int: kayak_trip_pct = 75; % at least 75% of trips are kayak

% Variables
var 0..min_people: kayak_trips;
var 0..max_motor_trips: motor_trips;

% Constraints
constraint cap_kayak * kayak_trips + cap_motor * motor_trips >= min_people;

% At least 75% of trips are by kayak:
% kayak_trips / (kayak_trips + motor_trips) >= 0.75
% => 100*kayak_trips >= 75*(kayak_trips + motor_trips)
constraint 100 * kayak_trips >= kayak_trip_pct * (kayak_trips + motor_trips);

% Objective
solve minimize time_kayak * kayak_trips + time_motor * motor_trips;