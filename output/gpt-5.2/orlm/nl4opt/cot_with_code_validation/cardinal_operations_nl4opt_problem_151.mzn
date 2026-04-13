% Parameters
int: mg_per_gummy = 3;
int: zn_per_gummy = 4;
int: mg_per_pill  = 2;
int: zn_per_pill  = 5;

int: min_pills = 10;
int: gummy_to_pill_ratio = 3; % gummies >= 3 * pills
int: max_mg = 200;

% Variables
var 0..(max_mg div mg_per_gummy): gummies;
var min_pills..(max_mg div mg_per_pill): pills;

var 0..max_mg: total_mg;
var 0..(zn_per_gummy*(max_mg div mg_per_gummy) + zn_per_pill*(max_mg div mg_per_pill)): total_zn;

% Constraints
constraint total_mg = mg_per_gummy * gummies + mg_per_pill * pills;
constraint total_mg <= max_mg;

constraint gummies >= gummy_to_pill_ratio * pills;

constraint total_zn = zn_per_gummy * gummies + zn_per_pill * pills;

% Objective
solve maximize total_zn;