% Parameters
int: large_capacity = 25;        % kg per large bag
int: tiny_capacity  = 6;         % kg per tiny bag
float: large_energy = 4.0;       % energy units per large bag
float: tiny_energy  = 1.5;       % energy units per tiny bag
float: energy_limit = 110.0;     % total available energy
int: min_tiny = 20;              % minimum number of tiny bags

% Variables
var 0..1000: large_bags;
var min_tiny..1000: tiny_bags;

% Constraints
constraint large_bags = 2 * tiny_bags;
constraint large_energy * int2float(large_bags) + tiny_energy * int2float(tiny_bags) <= energy_limit;

% Objective
var int: total_weight = large_capacity * large_bags + tiny_capacity * tiny_bags;
solve maximize total_weight;