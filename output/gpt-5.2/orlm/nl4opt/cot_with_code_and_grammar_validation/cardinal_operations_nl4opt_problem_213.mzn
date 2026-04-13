% Parameters
int: escalator_capacity = 20;
int: elevator_capacity  = 8;

int: escalator_space = 5;
int: elevator_space  = 2;

int: min_people_per_min = 400;

int: min_elevators = 2;
int: escalator_to_elevator_ratio = 3;

% Variables
var 0..(min_people_per_min div escalator_capacity + 1): E; % number of escalators
var min_elevators..(min_people_per_min div elevator_capacity + 10): L; % number of elevators

% Constraints
constraint escalator_capacity * E + elevator_capacity * L >= min_people_per_min;
constraint E >= escalator_to_elevator_ratio * L;
constraint L >= min_elevators;

% Objective
var int: total_space = escalator_space * E + elevator_space * L;
solve minimize total_space;