% Parameters
int: large_bag_capacity_kg = 25;          % kg of grain per large bag
int: large_bag_energy = 4;                % energy units per large bag (not used directly; scaled below)
int: tiny_bag_capacity_kg = 6;            % kg of grain per tiny bag
float: tiny_bag_energy = 1.5;             % energy units per tiny bag (not used directly; scaled below)
int: total_energy_available = 110;        % total available energy units
int: min_tiny_bags = 20;                  % minimum number of tiny bags required

% Variables
var int: num_large_bags;                  % number of large bags to transport
var int: num_tiny_bags;                   % number of tiny bags to transport
var int: total_grain_kg;                  % total transported grain weight (kg)

% Constraints
% --- Bag count domain constraints (non-negativity and minimum requirement) ---
constraint num_large_bags >= 0;
constraint num_tiny_bags  >= min_tiny_bags;

% --- Popularity / ratio constraint: twice as many large bags as tiny bags ---
constraint num_large_bags = 2 * num_tiny_bags;

% --- Energy budget constraint (avoid float by scaling energy units by 2) ---
% 4 -> 8/2, 1.5 -> 3/2, 110 -> 220/2
constraint 8 * num_large_bags + 3 * num_tiny_bags <= 2 * total_energy_available;

% --- Total grain transported definition ---
constraint total_grain_kg =
  large_bag_capacity_kg * num_large_bags +
  tiny_bag_capacity_kg  * num_tiny_bags;

% Objective
solve maximize total_grain_kg;