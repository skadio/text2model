% Parameters
int: water_small = 10;          % Water units required per small container
int: pill_small  = 15;          % Powdered pill units required per small container
int: paste_small = 20;          % Paste units produced per small container

int: water_large = 20;          % Water units required per large container
int: pill_large  = 20;          % Powdered pill units required per large container
int: paste_large = 30;          % Paste units produced per large container

int: water_available = 500;     % Total water units available
int: pill_available  = 700;     % Total powdered pill units available

% Variables
var 0..(water_available div water_small): num_small;   % Number of small containers used
var 0..(water_available div water_large): num_large;   % Number of large containers used

% Upper bound based on water-only feasibility (safe, integral)
var 0..(paste_small * (water_available div water_small)
      + paste_large * (water_available div water_large)): total_paste;  % Total paste produced

% Constraints
% Link total_paste to the number of containers used
constraint
  total_paste = paste_small * num_small + paste_large * num_large;

% Water availability constraint
constraint
  water_small * num_small + water_large * num_large <= water_available;

% Powdered pill availability constraint
constraint
  pill_small * num_small + pill_large * num_large <= pill_available;

% Objective
solve maximize total_paste;