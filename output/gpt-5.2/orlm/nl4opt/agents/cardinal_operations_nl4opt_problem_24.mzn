% Parameters
int: people_to_transport = 80;                 % Total number of people that must be transported

int: cap_large = 6;                            % People capacity of a large unit
int: cap_small = 2;                            % People capacity of a small unit

int: spots_large = 2;                          % Parking spots used by a large unit
int: spots_small = 1;                          % Parking spots used by a small unit

int: min_small_units = 5;                      % At least this many units must be small
int: min_large_percent = 75;                   % Large units must be at least this percent of all units


% Variables
var 0..people_to_transport: num_large_units;    % Number of large mobile production units
var 0..people_to_transport: num_small_units;    % Number of small mobile production units

var 0..(spots_large * people_to_transport): total_parking_spots;  % Total parking spots required


% Constraints

% --- Capacity constraint: enough seats to transport everyone ---
constraint
  cap_large * num_large_units + cap_small * num_small_units >= people_to_transport;

% --- Minimum number of small units (stars' preference) ---
constraint
  num_small_units >= min_small_units;

% --- Large units must be at least min_large_percent of all units ---
% Avoid division by cross-multiplying:
% num_large_units / (num_large_units + num_small_units) >= min_large_percent / 100
constraint
  100 * num_large_units >= min_large_percent * (num_large_units + num_small_units);

% --- Define total parking spots used by selected units ---
constraint
  total_parking_spots = spots_large * num_large_units + spots_small * num_small_units;


% Objective
solve minimize total_parking_spots;