include "globals.mzn";

% Decision variables (nonnegative integers)
var 0..1000: teachers;
var 0..1000: classrooms;
var 0..1000: textbooks;

% Constraints from the description
constraint teachers + 2 * classrooms + 3 * textbooks >= 50;
constraint 2 * teachers + classrooms <= 30;
constraint (teachers - classrooms) + textbooks >= 10;

% Objective: minimize total cost
var int: total_cost = 2 * teachers + 3 * classrooms + 4 * textbooks;

solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "classrooms = ", show(classrooms), "\n",
  "textbooks = ", show(textbooks), "\n",
  "total_cost = ", show(total_cost), "\n"
];