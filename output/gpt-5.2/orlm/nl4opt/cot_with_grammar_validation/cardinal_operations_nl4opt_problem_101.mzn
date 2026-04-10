% Parameters
int: water_sub = 10;
int: water_top = 6;
int: max_total_bags = 150;
int: min_top_bags = 10;
int: max_top_percent = 30; % percent of total

% Variables
var 0..max_total_bags: sub_bags;
var 0..max_total_bags: top_bags;
var 0..max_total_bags: total_bags;

% Constraints
constraint total_bags = sub_bags + top_bags;
constraint total_bags <= max_total_bags;
constraint top_bags >= min_top_bags;

% at most 30% of all bags can be topsoil: top_bags <= 0.30 * total_bags
constraint 100 * top_bags <= max_top_percent * total_bags;

% Objective
solve minimize water_sub * sub_bags + water_top * top_bags;