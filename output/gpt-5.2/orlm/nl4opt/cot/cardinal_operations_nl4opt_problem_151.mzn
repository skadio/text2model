% Parameters (with values embedded)
int: mg_per_gummy = 3;
int: zn_per_gummy = 4;
int: mg_per_pill  = 2;
int: zn_per_pill  = 5;

int: min_pills = 10;
int: gummies_per_pill_ratio = 3; % gummies >= 3 * pills
int: max_magnesium = 200;

% Variables
var 0..(max_magnesium div mg_per_gummy): gummies;
var min_pills..(max_magnesium div mg_per_pill): pills;

% Constraints
constraint gummies >= gummies_per_pill_ratio * pills;
constraint mg_per_gummy * gummies + mg_per_pill * pills <= max_magnesium;

% Objective
solve maximize (zn_per_gummy * gummies + zn_per_pill * pills);