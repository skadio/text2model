% Parameters (with values embedded)
float: reg_in_regmix = 0.8;
float: sour_in_regmix = 0.2;
float: reg_in_sourmix = 0.1;
float: sour_in_sourmix = 0.9;

float: profit_regmix = 3.0;
float: profit_sourmix = 5.0;

float: avail_regular = 80.0;
float: avail_sour = 60.0;

% Variables
var float: x_regmix;    % kg of regular mix
var float: x_sourmix;   % kg of sour surprise mix

% Constraints
constraint x_regmix >= 0.0;
constraint x_sourmix >= 0.0;

constraint reg_in_regmix * x_regmix + reg_in_sourmix * x_sourmix <= avail_regular;
constraint sour_in_regmix * x_regmix + sour_in_sourmix * x_sourmix <= avail_sour;

% Objective
solve maximize profit_regmix * x_regmix + profit_sourmix * x_sourmix;