% Parameters (with values embedded)
int: water_subsoil = 10;
int: water_topsoil = 6;

int: total_bags_max = 150;
int: topsoil_min = 10;
int: topsoil_percent_max = 30; % percent of total bags

% Variables
var 0..total_bags_max: subsoil;
var 0..total_bags_max: topsoil;
var 0..total_bags_max: total_bags;

% Constraints
constraint total_bags = subsoil + topsoil;
constraint total_bags <= total_bags_max;

constraint topsoil >= topsoil_min;

% at most 30% of all bags can be topsoil: topsoil <= 0.30 * total_bags
% avoid floats: 100*topsoil <= 30*total_bags
constraint 100 * topsoil <= topsoil_percent_max * total_bags;

% Objective
solve minimize water_subsoil * subsoil + water_topsoil * topsoil;