% Syrup treatment optimization (all data embedded)

% Decision variables: number of servings (nonnegative integers)
var 0..100: s1;  % servings of syrup 1
var 0..100: s2;  % servings of syrup 2

% Data (per serving)
float: throat1 = 0.5;
float: lungs1  = 0.4;
float: sugar1  = 0.5;

float: throat2 = 0.2;
float: lungs2  = 0.5;
float: sugar2  = 0.3;

% Requirements
float: throat_max = 5.0;  % at most
float: lungs_min  = 4.0;  % at least

% Constraints
constraint throat1 * s1 + throat2 * s2 <= throat_max;
constraint lungs1  * s1 + lungs2  * s2 >= lungs_min;

% Objective: minimize sugar intake
var float: total_sugar = sugar1 * s1 + sugar2 * s2;
solve minimize total_sugar;

output [
  "s1 = ", show(s1), " servings\n",
  "s2 = ", show(s2), " servings\n",
  "total_sugar = ", show(total_sugar), "\n",
  "throat_medicine = ", show(throat1*s1 + throat2*s2), "\n",
  "lungs_medicine = ", show(lungs1*s1 + lungs2*s2), "\n"
];