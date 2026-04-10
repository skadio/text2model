% Parameters
int: resin_total = 3000;

int: resin_molar = 20;
int: resin_canine = 15;

float: pain_molar = 3.0;
float: pain_canine = 2.3;

int: min_molars_reserved = 45;

% Variables
int: max_molars = resin_total div resin_molar;
int: max_canines = resin_total div resin_canine;

var 0..max_molars: molars;
var 0..max_canines: canines;

var float: total_pain;

% Constraints
constraint resin_molar * molars + resin_canine * canines <= resin_total;

% Reserve materials to fill at least 45 molars
constraint molars >= min_molars_reserved;

% At least 60% of cavities filled must be canines:
% canines / (molars + canines) >= 0.6  <=>  2*canines >= 3*molars
constraint 2 * canines >= 3 * molars;

constraint total_pain = pain_molar * int2float(molars) + pain_canine * int2float(canines);

% Objective
solve minimize total_pain;