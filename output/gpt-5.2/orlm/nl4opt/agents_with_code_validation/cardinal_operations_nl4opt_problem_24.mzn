% Parameters
int: people_to_transport = 80;              % Total number of people to transport
int: cap_large_unit = 6;                    % People capacity of a large mobile production unit
int: cap_small_unit = 2;                    % People capacity of a small mobile production unit
int: spots_large_unit = 2;                  % Parking spots used by a large unit
int: spots_small_unit = 1;                  % Parking spots used by a small unit
int: min_small_units = 5;                   % At least this many units must be small
float: min_large_fraction = 0.75;           % Large units must be at least this fraction of all units (not used directly)

% Variables
var 0..people_to_transport: num_large_units; % Number of large mobile production units
var 0..people_to_transport: num_small_units; % Number of small mobile production units
var 0..(spots_large_unit*people_to_transport + spots_small_unit*people_to_transport): total_spots; % Total parking spots used

% Constraints
%--- Capacity constraint: transport at least the required number of people
constraint
  cap_large_unit * num_large_units + cap_small_unit * num_small_units >= people_to_transport;

%--- Minimum number of small units (movie stars' preference)
constraint
  num_small_units >= min_small_units;

%--- Large units must be at least 75% of all units
% Avoid float usage by cross-multiplying:
% num_large_units / (num_large_units + num_small_units) >= 3/4
% => 4*num_large_units >= 3*(num_large_units + num_small_units)
constraint
  4 * num_large_units >= 3 * (num_large_units + num_small_units);

%--- Define total parking spots used
constraint
  total_spots = spots_large_unit * num_large_units + spots_small_unit * num_small_units;

% Objective
solve minimize total_spots;