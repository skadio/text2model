% Parameters
int: resin_total = 3000;
int: resin_molar = 20;
int: resin_canine = 15;

float: pk_molar = 3.0;
float: pk_canine = 2.3;

float: canine_share_min = 0.60;
int: molar_min = 45;

int: molar_ub = resin_total div resin_molar;
int: canine_ub = resin_total div resin_canine;

% Variables
var 0..molar_ub: molars;
var 0..canine_ub: canines;

var float: total_painkiller;

% Constraints
constraint resin_molar * molars + resin_canine * canines <= resin_total;

constraint molars >= molar_min;

% At least 60% canines: canines / (molars+canines) >= 0.60
% Equivalent linear form: (1-0.60)*canines - 0.60*molars >= 0
constraint (1.0 - canine_share_min) * int2float(canines) - canine_share_min * int2float(molars) >= 0.0;

constraint total_painkiller = pk_molar * int2float(molars) + pk_canine * int2float(canines);

% Objective
solve minimize total_painkiller;