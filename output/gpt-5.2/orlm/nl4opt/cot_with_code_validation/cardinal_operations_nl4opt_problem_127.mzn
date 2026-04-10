% Parameters
int: resin_total = 3000;
int: resin_molar = 20;
int: resin_canine = 15;

float: pain_molar = 3.0;
float: pain_canine = 2.3;

float: min_canine_fraction = 0.60;
int: min_molars = 45;

% Variables
int: max_molars = resin_total div resin_molar;
int: max_canines = resin_total div resin_canine;

var 0..max_molars: m;     % number of molars
var 0..max_canines: c;    % number of canines

var float: total_pain;

% Constraints
constraint resin_molar * m + resin_canine * c <= resin_total;

constraint m >= min_molars;

% At least 60% of filled cavities are canines:
% c / (m+c) >= 0.60  <=>  2*c >= 3*m  (after multiplying by 10 and simplifying)
constraint 2 * c >= 3 * m;

constraint total_pain = pain_molar * int2float(m) + pain_canine * int2float(c);

% Objective
solve minimize total_pain;