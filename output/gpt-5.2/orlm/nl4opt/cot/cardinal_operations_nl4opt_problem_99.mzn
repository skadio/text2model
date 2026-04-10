% Parameters (with values embedded)
int: employees_available = 150;
int: emp_small = 3;
int: emp_large = 5;
int: area_small = 50;
int: area_large = 80;

int: min_small = 10;
int: min_large = 6;
int: ratio_small_per_large = 3;

% Variables
var 0..employees_available: num_small;
var 0..employees_available: num_large;

% Constraints
constraint emp_small * num_small + emp_large * num_large <= employees_available;
constraint num_small >= ratio_small_per_large * num_large;
constraint num_small >= min_small;
constraint num_large >= min_large;

% Objective
var 0..(area_small * employees_available): total_area = area_small * num_small + area_large * num_large;

solve maximize total_area;

output [
  "num_small=", show(num_small), "\n",
  "num_large=", show(num_large), "\n",
  "total_area=", show(total_area), "\n"
];