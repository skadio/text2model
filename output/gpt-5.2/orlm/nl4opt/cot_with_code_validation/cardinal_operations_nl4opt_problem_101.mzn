% Parameters
int: water_subsoil = 10;
int: water_topsoil = 6;
int: total_bags = 150;
int: min_topsoil = 10;
float: max_topsoil_ratio = 0.30;

% Variables
var 0..total_bags: subsoil;
var 0..total_bags: topsoil;
var 0..(water_subsoil * total_bags): total_water;

% Constraints
constraint subsoil + topsoil = total_bags;
constraint topsoil >= min_topsoil;

% at most 30% topsoil: topsoil <= 0.30 * (subsoil + topsoil)
% avoid floats by multiplying: 10*topsoil <= 3*(subsoil + topsoil)  => 7*topsoil <= 3*subsoil
constraint 10 * topsoil <= 3 * (subsoil + topsoil);

constraint total_water = water_subsoil * subsoil + water_topsoil * topsoil;

% Objective
solve minimize total_water;