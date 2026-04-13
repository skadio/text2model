% Parameters
int: escalator_capacity = 20;
int: elevator_capacity  = 8;

int: escalator_space = 5;
int: elevator_space  = 2;

int: min_people_per_minute = 400;
int: min_elevators = 2;
int: escalators_at_least_times_elevators = 3;

% Variables
var 0..(min_people_per_minute div escalator_capacity + 100): E; % number of escalators
var min_elevators..(min_people_per_minute div elevator_capacity + 100): L; % number of elevators

var 0..10000: total_space;

% Constraints
constraint escalator_capacity * E + elevator_capacity * L >= min_people_per_minute;
constraint E >= escalators_at_least_times_elevators * L;

constraint total_space = escalator_space * E + elevator_space * L;

% Objective
solve minimize total_space;