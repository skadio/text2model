% Diet optimization: maximize zinc intake with magnesium cap

% Decision variables
var 0..1000: gummies;  % number of gummies
var 0..1000: pills;    % number of pills

% Nutrient content
int: mg_per_gummy = 3;
int: zn_per_gummy = 4;
int: mg_per_pill  = 2;
int: zn_per_pill  = 5;

% Constraints
constraint pills >= 10;
constraint gummies >= 3 * pills;
constraint mg_per_gummy * gummies + mg_per_pill * pills <= 200;

% Objective: maximize zinc intake
var int: total_zinc = zn_per_gummy * gummies + zn_per_pill * pills;
solve maximize total_zinc;

output [
  "gummies = ", show(gummies), "\n",
  "pills = ", show(pills), "\n",
  "total_magnesium = ", show(mg_per_gummy * gummies + mg_per_pill * pills), "\n",
  "total_zinc = ", show(total_zinc), "\n"
];