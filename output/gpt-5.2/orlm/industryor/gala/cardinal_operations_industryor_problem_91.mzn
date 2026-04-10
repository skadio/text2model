% Transportation planning: choose buses/minibuses to carry 400 students
% with limited vehicles and drivers, minimizing rental cost.

include "globals.mzn";

% Data (embedded)
int: students = 400;

int: max_buses = 10;
int: bus_seats = 50;
int: bus_cost  = 800;

int: max_minibuses = 8;
int: minibus_seats = 40;
int: minibus_cost  = 600;

int: drivers = 9;

% Decision variables
var 0..max_buses: buses;
var 0..max_minibuses: minibuses;

% Constraints
constraint buses + minibuses <= drivers; % each vehicle needs a driver
constraint bus_seats * buses + minibus_seats * minibuses >= students;

% Objective
var int: total_cost = bus_cost * buses + minibus_cost * minibuses;

solve minimize total_cost;

output [
  "Buses = ", show(buses), "\n",
  "Minibuses = ", show(minibuses), "\n",
  "Total seats = ", show(bus_seats*buses + minibus_seats*minibuses), "\n",
  "Total cost = £", show(total_cost), "\n"
];