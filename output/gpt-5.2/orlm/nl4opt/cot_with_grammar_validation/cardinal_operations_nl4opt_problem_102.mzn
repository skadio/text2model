% Parameters
int: cost_rice = 3;
int: cost_kebab = 2;

int: cal_rice = 300;
int: cal_kebab = 200;

float: prot_rice = 4.5;
float: prot_kebab = 4.0;

int: min_cal = 2200;
float: min_prot = 30.0;

% Variables
var 0..100: rice_servings;
var 0..100: kebab_servings;

% Constraints
constraint cal_rice * rice_servings + cal_kebab * kebab_servings >= min_cal;
constraint prot_rice * int2float(rice_servings) + prot_kebab * int2float(kebab_servings) >= min_prot;

% Objective
solve minimize cost_rice * rice_servings + cost_kebab * kebab_servings;