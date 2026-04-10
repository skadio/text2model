% Diet LP (integer servings) minimized cost with calorie and protein minimums

% Data (embedded from problem statement)
int: cost_rice = 3;
int: cal_rice  = 300;
int: prot_rice_tenths = 45;   % 4.5 g = 45 tenths

int: cost_kebab = 2;
int: cal_kebab  = 200;
int: prot_kebab_tenths = 40;  % 4.0 g = 40 tenths

int: min_cal = 2200;
int: min_prot_tenths = 300;   % 30.0 g = 300 tenths

% Decision variables: number of servings (nonnegative integers)
var 0..100: rice;
var 0..100: kebab;

% Nutrition constraints
constraint cal_rice * rice + cal_kebab * kebab >= min_cal;
constraint prot_rice_tenths * rice + prot_kebab_tenths * kebab >= min_prot_tenths;

% Objective: minimize total cost
var 0..1000: total_cost = cost_rice * rice + cost_kebab * kebab;

solve minimize total_cost;

output [
  "rice servings = ", show(rice), "\n",
  "kebab servings = ", show(kebab), "\n",
  "total cost ($) = ", show(total_cost), "\n",
  "total calories = ", show(cal_rice * rice + cal_kebab * kebab), "\n",
  "total protein (g) = ", show((prot_rice_tenths * rice + prot_kebab_tenths * kebab) div 10),
  ".", show((prot_rice_tenths * rice + prot_kebab_tenths * kebab) mod 10), "\n"
];