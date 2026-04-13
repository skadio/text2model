% Sore throat treatment: minimize sugar intake

% Parameters
float: throat_med_s1 = 0.5;
float: lung_med_s1   = 0.4;
float: sugar_s1      = 0.5;

float: throat_med_s2 = 0.2;
float: lung_med_s2   = 0.5;
float: sugar_s2      = 0.3;

float: throat_max = 5.0;
float: lung_min   = 4.0;

% Scale to avoid floats (multiply all coefficients by 10)
int: throat_med_s1_i = 5;
int: lung_med_s1_i   = 4;
int: sugar_s1_i      = 5;

int: throat_med_s2_i = 2;
int: lung_med_s2_i   = 5;
int: sugar_s2_i      = 3;

int: throat_max_i = 50;
int: lung_min_i   = 40;

% Variables: servings (assume integer servings)
% Upper bound: all throat medicine from the smallest per-serving contributor (2/10)
var 0..(throat_max_i div throat_med_s2_i): x1;
var 0..(throat_max_i div throat_med_s2_i): x2;

% Constraints
constraint throat_med_s1_i * x1 + throat_med_s2_i * x2 <= throat_max_i;
constraint lung_med_s1_i * x1 + lung_med_s2_i * x2 >= lung_min_i;

% Objective: minimize sugar
solve minimize sugar_s1_i * x1 + sugar_s2_i * x2;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "sugar=", show((sugar_s1_i * x1 + sugar_s2_i * x2) / 10.0), "\n"
];