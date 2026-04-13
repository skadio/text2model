% Parameters
int: water_available = 500;            % Total units of water available
int: powder_available = 700;           % Total units of powdered pill available

int: water_per_small = 10;             % Water units needed per small container
int: powder_per_small = 15;            % Powder units needed per small container
int: paste_per_small = 20;             % Paste units produced per small container

int: water_per_large = 20;             % Water units needed per large container
int: powder_per_large = 20;            % Powder units needed per large container
int: paste_per_large = 30;             % Paste units produced per large container

% Variables
var 0..(water_available div water_per_small): small_containers;  % Number of small containers used
var 0..(water_available div water_per_large): large_containers;  % Number of large containers used

% Upper bound based on using only small containers (safe, though not tight)
var 0..(water_available div water_per_small) * paste_per_small: total_paste;

% Constraints
% Resource constraint: total water used by all containers cannot exceed available water
constraint
  water_per_small * small_containers + water_per_large * large_containers
  <= water_available;

% Resource constraint: total powder used by all containers cannot exceed available powder
constraint
  powder_per_small * small_containers + powder_per_large * large_containers
  <= powder_available;

% Accounting constraint: total paste produced from chosen containers
constraint
  total_paste = paste_per_small * small_containers + paste_per_large * large_containers;

% Objective
solve maximize total_paste;