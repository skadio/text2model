% Airport escalator/elevator installation optimization
% Data embedded as per problem statement.

include "globals.mzn";

% Parameters
int: cap_escalator = 20;     % people per minute
int: cap_elevator  = 8;      % people per minute
int: space_escalator = 5;    % space units
int: space_elevator  = 2;    % space units
int: min_capacity = 400;

int: min_elevators = 2;
int: escalators_at_least_times_elevators = 3; % E >= 3*L

% Decision variables (upper bounds are safe, derived from capacity)
var 0..(min_capacity div cap_escalator + 50): E; % number of escalators
var 0..(min_capacity div cap_elevator + 50):  L; % number of elevators

% Constraints
constraint cap_escalator * E + cap_elevator * L >= min_capacity;
constraint E >= escalators_at_least_times_elevators * L;
constraint L >= min_elevators;

% Objective: minimize total space
var int: total_space = space_escalator * E + space_elevator * L;
solve minimize total_space;

output [
  "Escalators = ", show(E), "\n",
  "Elevators  = ", show(L), "\n",
  "Capacity   = ", show(cap_escalator * E + cap_elevator * L), " people/min\n",
  "Space      = ", show(total_space), " units\n"
];