% Airport escalator/elevator installation optimization
% Minimize space subject to capacity and ratio constraints

int: cap_escalator = 20;   % people/min
int: cap_elevator  = 8;    % people/min

int: space_escalator = 5;  % units
int: space_elevator  = 2;  % units

int: required_capacity = 400;

var 0..1000: E;  % number of escalators
var 0..1000: L;  % number of elevators

constraint cap_escalator * E + cap_elevator * L >= required_capacity;
constraint E >= 3 * L;     % at least three times more escalators than elevators
constraint L >= 2;         % at least 2 elevators

var int: total_space = space_escalator * E + space_elevator * L;

solve minimize total_space;

output [
  "Escalators = ", show(E), "\n",
  "Elevators  = ", show(L), "\n",
  "Total space = ", show(total_space), "\n",
  "Total capacity = ", show(cap_escalator * E + cap_elevator * L), " people/min\n"
];