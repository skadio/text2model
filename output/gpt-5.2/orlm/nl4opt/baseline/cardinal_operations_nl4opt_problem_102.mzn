% Diet LP: minimize cost of Kebabs and Rice subject to nutrition requirements

% Data
int: cost_rice = 3;
int: cal_rice  = 300;
float: prot_rice = 4.5;

int: cost_kebab = 2;
int: cal_kebab  = 200;
int: prot_kebab = 4;

int: min_cal = 2200;
int: min_prot = 30;

% Decision variables: servings per day (continuous, nonnegative)
var float: rice;
var float: kebab;

% Constraints
constraint rice >= 0.0;
constraint kebab >= 0.0;

constraint cal_rice * rice + cal_kebab * kebab >= min_cal;
constraint prot_rice * rice + float(prot_kebab) * kebab >= float(min_prot);

% Objective: minimize total cost
var float: total_cost = float(cost_rice) * rice + float(cost_kebab) * kebab;

solve minimize total_cost;

output [
  "rice servings = ", show(rice), "\n",
  "kebab servings = ", show(kebab), "\n",
  "total cost = $", show(total_cost), "\n"
];