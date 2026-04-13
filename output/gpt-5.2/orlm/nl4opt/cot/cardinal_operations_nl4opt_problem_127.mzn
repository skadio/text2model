% Parameters (with values embedded)
int: total_resin = 3000;
float: resin_molar = 20.0;
float: resin_canine = 15.0;

float: pain_molar = 3.0;
float: pain_canine = 2.3;

int: min_molars = 45;
float: min_canine_fraction = 0.6;

% Variables
var 0..(total_resin div 20): molars;
var 0..(total_resin div 15): canines;

% Constraints
constraint 20 * molars + 15 * canines <= total_resin;
constraint molars >= min_molars;

% At least 60% of cavities filled must be canines:
% canines / (molars + canines) >= 0.6  <=>  canines >= 0.6*(molars+canines)
% <=> 0.4*canines >= 0.6*molars  <=>  2*canines >= 3*molars
constraint 2 * canines >= 3 * molars;

% Objective
var float: total_pain = pain_molar * int2float(molars) + pain_canine * int2float(canines);
solve minimize total_pain;