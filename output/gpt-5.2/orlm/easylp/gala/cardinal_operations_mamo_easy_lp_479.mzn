include "globals.mzn";

% Data (embedded from problem statement)
int: teacher_cost = 5000;
int: classroom_cost = 3000;

% Decision variables (nonnegative integers)
var 0..1000: teachers;
var 0..1000: classrooms;

% Constraints
constraint teachers >= classrooms;                 % at least as many teachers as classrooms
constraint 30 * teachers - classrooms >= 0;        % quality/class size condition
constraint 20 * teachers + classrooms >= 100;      % minimum requirement

% Objective: minimize total annual cost
var 0..intmax: total_cost = teacher_cost * teachers + classroom_cost * classrooms;

solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "classrooms = ", show(classrooms), "\n",
  "min_total_annual_cost = ", show(total_cost), "\n"
];