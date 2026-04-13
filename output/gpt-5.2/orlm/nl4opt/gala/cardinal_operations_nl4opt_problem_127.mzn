% Dentist scheduling: minimize pain killer subject to resin and mix constraints.
% All data embedded as requested.

% Data
int: resin_available = 3000;
int: resin_molar = 20;
int: resin_canine = 15;

float: pain_molar = 3.0;
float: pain_canine = 2.3;

float: min_canine_fraction = 0.60;
int: min_molars_reserved = 45;

% Decision variables
var 0..resin_available div resin_molar: molars;    % number of molars filled
var 0..resin_available div resin_canine: canines;  % number of canines filled

% Constraints
constraint resin_molar * molars + resin_canine * canines <= resin_available;

% Reserve materials to fill at least 45 molars
constraint molars >= min_molars_reserved;

% At least 60% of filled cavities must be canines:
% canines / (molars + canines) >= 0.60
% Equivalent linear form: 2*canines >= 3*molars  (since 0.6 = 3/5)
constraint 2 * canines >= 3 * molars;

% Objective: minimize total pain killer used
var float: total_pain = pain_molar * int2float(molars) + pain_canine * int2float(canines);

solve minimize total_pain;

output [
  "molars = ", show(molars), "\n",
  "canines = ", show(canines), "\n",
  "resin_used = ", show(resin_molar * molars + resin_canine * canines), "\n",
  "total_pain = ", show(total_pain), "\n"
];