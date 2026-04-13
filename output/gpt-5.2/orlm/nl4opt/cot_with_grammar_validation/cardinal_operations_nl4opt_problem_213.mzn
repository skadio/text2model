% Parameters
int: escalator_capacity = 20;
int: elevator_capacity  = 8;

int: escalator_space = 5;
int: elevator_space  = 2;

int: min_capacity = 400;
int: min_elevators = 2;

% Variables
var 0..ceil(min_capacity / escalator_capacity): E; % number of escalators
var 0..ceil(min_capacity / elevator_capacity):  L; % number of elevators

var 0..(escalator_space * ceil(min_capacity / escalator_capacity)
      + elevator_space * ceil(min_capacity / elevator_capacity)): total_space;

% Constraints
constraint escalator_capacity * E + elevator_capacity * L >= min_capacity;
constraint E >= 3 * L;
constraint L >= min_elevators;

constraint total_space = escalator_space * E + elevator_space * L;

% Objective
solve minimize total_space;