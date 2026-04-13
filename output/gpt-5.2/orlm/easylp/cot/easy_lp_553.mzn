% Parameters (with values embedded)
int: max_total_hires = 100;
int: min_X = 30;
int: min_Y = 20;
int: min_Z = 10;

int: salary_X = 5000;
int: salary_Y = 4000;
int: salary_Z = 6000;

% Variables
var 0..max_total_hires: hires_X;
var 0..max_total_hires: hires_Y;
var 0..max_total_hires: hires_Z;

var 0..(salary_X*max_total_hires + salary_Y*max_total_hires + salary_Z*max_total_hires): total_salary_cost;

% Constraints
constraint hires_X >= min_X;
constraint hires_Y >= min_Y;
constraint hires_Z >= min_Z;

constraint hires_X + hires_Y + hires_Z <= max_total_hires;

constraint total_salary_cost = salary_X*hires_X + salary_Y*hires_Y + salary_Z*hires_Z;

% Objective
solve minimize total_salary_cost;

output [
  "hires_X=", show(hires_X), "\n",
  "hires_Y=", show(hires_Y), "\n",
  "hires_Z=", show(hires_Z), "\n",
  "minimum_total_salary_cost=$", show(total_salary_cost), "\n"
];