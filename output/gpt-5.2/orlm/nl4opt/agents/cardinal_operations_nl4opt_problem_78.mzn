% Parameters
int: large_bag_capacity_kg = 25;        % kg of grain per large bag
int: large_bag_energy = 4;              % energy units per large bag
int: tiny_bag_capacity_kg = 6;          % kg of grain per tiny bag
float: tiny_bag_energy = 1.5;           % energy units per tiny bag (kept for clarity; not used directly)
int: total_energy_available = 110;      % total available energy units
int: min_tiny_bags = 20;                % minimum number of tiny bags required
int: large_to_tiny_ratio = 2;           % large bags must be twice the number of tiny bags

% Variables
var int: num_large_bags;                % number of large bags to transport
var int: num_tiny_bags;                 % number of tiny bags to transport
var int: total_grain_kg;                % total transported grain (kg)

% Constraints
% --- Non-negativity of decision variables ---
constraint num_large_bags >= 0;
constraint num_tiny_bags >= 0;

% --- Popularity/ratio requirement: large bags are twice tiny bags ---
constraint num_large_bags = large_to_tiny_ratio * num_tiny_bags;

% --- Minimum tiny bags requirement ---
constraint num_tiny_bags >= min_tiny_bags;

% --- Energy budget constraint (avoid float issues by scaling by 2) ---
% 4*L + 1.5*T <= 110  <=>  8*L + 3*T <= 220
constraint 2 * large_bag_energy * num_large_bags + 3 * num_tiny_bags
          <= 2 * total_energy_available;

% --- Total grain transported (definition) ---
constraint total_grain_kg =
    large_bag_capacity_kg * num_large_bags + tiny_bag_capacity_kg * num_tiny_bags;

% Objective
solve maximize total_grain_kg;