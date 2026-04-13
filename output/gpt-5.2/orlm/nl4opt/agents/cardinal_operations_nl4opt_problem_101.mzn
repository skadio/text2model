% Parameters
int: water_per_subsoil = 10;     % water units per bag of subsoil per day
int: water_per_topsoil = 6;      % water units per bag of topsoil per day
int: max_total_bags = 150;       % capacity limit: total bags (subsoil + topsoil)
int: min_topsoil_bags = 10;      % minimum required topsoil bags
int: max_topsoil_percent = 30;   % at most 30% of total bags can be topsoil

% Variables
var 0..max_total_bags: subsoil_bags;  % number of subsoil bags to buy
var 0..max_total_bags: topsoil_bags;  % number of topsoil bags to buy
var 0..(water_per_subsoil*max_total_bags): total_water; % total water units per day

% Constraints
% Total bag capacity constraint (truck limit)
constraint subsoil_bags + topsoil_bags <= max_total_bags;

% Minimum required topsoil bags
constraint topsoil_bags >= min_topsoil_bags;

% Topsoil proportion constraint: topsoil_bags <= 30% of total bags
% Implemented without floats: 100 * topsoil_bags <= 30 * (subsoil_bags + topsoil_bags)
constraint 100 * topsoil_bags <= max_topsoil_percent * (subsoil_bags + topsoil_bags);

% Define total water usage from chosen quantities
constraint total_water = water_per_subsoil * subsoil_bags + water_per_topsoil * topsoil_bags;

% Objective
solve minimize total_water;