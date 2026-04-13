% Data (embedded)
float: throat_med_s1 = 0.5;
float: lungs_med_s1  = 0.4;
float: throat_med_s2 = 0.2;
float: lungs_med_s2  = 0.5;

float: sugar_s1 = 0.5;
float: sugar_s2 = 0.3;

float: throat_med_max = 5.0; % at most
float: lungs_med_min  = 4.0; % at least

% Use an LP solver to avoid search/timeouts on continuous variables
include "mznlib/linear.mzn";

% Decision variables: nonnegative real servings
var float: servings_s1 >= 0.0;
var float: servings_s2 >= 0.0;

% Constraints
constraint throat_med_s1 * servings_s1 + throat_med_s2 * servings_s2 <= throat_med_max;
constraint lungs_med_s1  * servings_s1 + lungs_med_s2  * servings_s2 >= lungs_med_min;

% Objective: minimize sugar intake
var float: total_sugar = sugar_s1 * servings_s1 + sugar_s2 * servings_s2;

solve minimize total_sugar;

output [
  "servings_s1 = ", show(servings_s1), "\n",
  "servings_s2 = ", show(servings_s2), "\n",
  "total_sugar = ", show(total_sugar), "\n"
];