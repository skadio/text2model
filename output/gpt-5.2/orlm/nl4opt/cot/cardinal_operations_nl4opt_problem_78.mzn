% Parameters (with values embedded)
int: large_capacity = 25;         % kg per large bag
int: tiny_capacity  = 6;          % kg per tiny bag
float: energy_large = 4.0;        % energy units per large bag
float: energy_tiny  = 1.5;        % energy units per tiny bag
float: energy_total = 110.0;      % total available energy
int: min_tiny = 20;               % at least 20 tiny bags

% Variables
var 0..1000: large_bags;
var 0..1000: tiny_bags;

% Constraints
constraint large_bags = 2 * tiny_bags;
constraint tiny_bags >= min_tiny;
constraint energy_large * int2float(large_bags) + energy_tiny * int2float(tiny_bags) <= energy_total;

% Objective
var int: total_weight = large_capacity * large_bags + tiny_capacity * tiny_bags;
solve maximize total_weight;