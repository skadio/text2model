% Parameters
% Effectiveness time per unit (minutes)
float: time_per_unit_sulfate = 0.5;
float: time_per_unit_ginger  = 0.75;

% Minimum required units of sulfate
int: min_sulfate_units = 100;

% Total required units of ingredients (sulfate + ginger)
int: total_units = 400;

% Maximum sulfate allowed relative to ginger: sulfate <= 2 * ginger
int: sulfate_to_ginger_ratio_max = 2;

% Variables
% Units of each ingredient to add (non-negative integers)
var 0..total_units: sulfate_units;  % units of sulfate
var 0..total_units: ginger_units;   % units of ginger

% Constraints
% Ingredient total composition: sulfate + ginger must equal the required total
constraint sulfate_units + ginger_units = total_units;

% Minimum sulfate requirement
constraint sulfate_units >= min_sulfate_units;

% Safety ratio: sulfate must be at most twice the ginger amount
constraint sulfate_units <= sulfate_to_ginger_ratio_max * ginger_units;

% Objective
solve minimize time_per_unit_sulfate * sulfate_units + time_per_unit_ginger * ginger_units;