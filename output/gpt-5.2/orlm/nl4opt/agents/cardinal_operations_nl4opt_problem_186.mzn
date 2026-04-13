% Parameters
int: small_capacity = 20;          % Ore units per small wagon
int: large_capacity = 50;          % Ore units per large wagon
int: demand = 2000;                % Total ore units to transport
int: min_large = 10;               % Minimum number of large wagons required
int: small_to_large_ratio = 2;     % Small wagons must be at least this multiple of large wagons

% Variables
% Upper bounds: in worst case you could satisfy demand using only one wagon type.
var 0..(ceil(demand / small_capacity) + ceil(demand / large_capacity)): small_wagons;
var min_large..ceil(demand / large_capacity): large_wagons;
var 0..(ceil(demand / small_capacity) + ceil(demand / large_capacity)): total_wagons;

% Constraints
% Meet ore transport demand (total capacity must cover required ore)
constraint
  small_capacity * small_wagons + large_capacity * large_wagons >= demand;

% Ramp space rule: small wagons at least a multiple of large wagons
constraint
  small_wagons >= small_to_large_ratio * large_wagons;

% Define total wagons as the sum of small and large wagons
constraint
  total_wagons = small_wagons + large_wagons;

% Objective
solve minimize total_wagons;