% Employee scheduling across three shifts with embedded data

int: max_total_employees = 24;

int: min_morning = 4;
int: min_afternoon = 6;
int: min_night = 5;

int: cost_morning = 8;    % $ per hour per employee
int: cost_afternoon = 6;  % $ per hour per employee
int: cost_night = 5;      % $ per hour per employee

var min_morning..max_total_employees: X; % morning employees
var min_afternoon..max_total_employees: Y; % afternoon employees
var min_night..max_total_employees: Z; % night employees

constraint X + Y + Z <= max_total_employees;

var int: total_cost = cost_morning * X + cost_afternoon * Y + cost_night * Z;

solve minimize total_cost;

output [
  "X(morning) = ", show(X), "\n",
  "Y(afternoon) = ", show(Y), "\n",
  "Z(night) = ", show(Z), "\n",
  "Minimum total labor cost ($/hour) = ", show(total_cost), "\n"
];