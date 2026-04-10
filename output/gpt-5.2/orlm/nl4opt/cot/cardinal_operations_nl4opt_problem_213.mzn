% Parameters (with values embedded)
int: cap_escalator = 20;
int: cap_elevator  = 8;
int: space_escalator = 5;
int: space_elevator  = 2;

int: min_capacity = 400;
int: min_elevators = 2;

% Variables
var 0..(min_capacity div cap_escalator + 100): e; % number of escalators
var min_elevators..(min_capacity div cap_elevator + 100): l; % number of elevators

% Constraints
constraint cap_escalator * e + cap_elevator * l >= min_capacity;
constraint e >= 3 * l;
constraint l >= min_elevators;

% Objective
var int: total_space = space_escalator * e + space_elevator * l;
solve minimize total_space;

output [
  "escalators = ", show(e), "\n",
  "elevators  = ", show(l), "\n",
  "total_space = ", show(total_space), "\n"
];