% Maximize total grain transported subject to energy and ratio constraints.

int: large_capacity = 25;     % kg per large bag
int: tiny_capacity  = 6;      % kg per tiny bag

float: energy_large = 4.0;    % energy per large bag
float: energy_tiny  = 1.5;    % energy per tiny bag
float: energy_budget = 110.0;

int: min_tiny = 20;

% Decision variables
var 0..1000: L;  % number of large bags
var 0..1000: T;  % number of tiny bags

% Constraints
constraint L = 2 * T;  % twice as many large as tiny
constraint T >= min_tiny;

% Energy constraint: 4L + 1.5T <= 110  -> 8L + 3T <= 220 (multiply by 2)
constraint 8 * L + 3 * T <= 220;

% Objective: maximize total weight (kg)
var int: total_weight = large_capacity * L + tiny_capacity * T;

solve maximize total_weight;

output [
  "Large bags = ", show(L), "\n",
  "Tiny bags  = ", show(T), "\n",
  "Total weight (kg) = ", show(total_weight), "\n"
];