% Sore throat treatment: minimize sugar intake

% Parameters
float: throat_med_s1 = 0.5;
float: lungs_med_s1  = 0.4;
float: sugar_s1      = 0.5;

float: throat_med_s2 = 0.2;
float: lungs_med_s2  = 0.5;
float: sugar_s2      = 0.3;

float: throat_med_max = 5.0;
float: lungs_med_min  = 4.0;

% Use finite integer servings (scaled by 10 to model one-decimal servings)
% Let y1 = 10*x1 and y2 = 10*x2
int: SCALE = 10;

var 0..1000: y1; % scaled servings of syrup 1
var 0..1000: y2; % scaled servings of syrup 2

% Constraints (multiply by 10 to remove decimals)
% Throat: 0.5*x1 + 0.2*x2 <= 5  -> 5*y1 + 2*y2 <= 500
constraint 5*y1 + 2*y2 <= 500;

% Lungs: 0.4*x1 + 0.5*x2 >= 4  -> 4*y1 + 5*y2 >= 400
constraint 4*y1 + 5*y2 >= 400;

% Objective (minimize sugar): 0.5*x1 + 0.3*x2 -> 0.5*(y1/10) + 0.3*(y2/10)
% Multiply by 10: minimize 5*y1 + 3*y2
var 0..10000: total_sugar10 = 5*y1 + 3*y2;

solve minimize total_sugar10;

output [
  "servings_syrup1=", show(y1 / SCALE), "\n",
  "servings_syrup2=", show(y2 / SCALE), "\n",
  "total_sugar=", show(total_sugar10 / SCALE), "\n"
];