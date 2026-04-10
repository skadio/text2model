% Parameters
int: tooth_med_available = 2000;      % Total available units of tooth medication
int: tooth_per_small = 10;            % Tooth medication units per small bone
int: meat_per_small  = 12;            % Meat units per small bone
int: tooth_per_large = 15;            % Tooth medication units per large bone
int: meat_per_large  = 15;            % Meat units per large bone

float: min_small_fraction = 0.50;     % At least this fraction of all bones must be small
int: min_large_bones = 30;            % Must make at least this many large bones

% Upper bounds derived from tooth medication availability
int: max_small = tooth_med_available div tooth_per_small;
int: max_large = tooth_med_available div tooth_per_large;

% Variables
var 0..max_small: small_bones;        % Number of small bones produced
var 0..max_large: large_bones;        % Number of large bones produced

var 0..(meat_per_small*max_small + meat_per_large*max_large): total_meat; % Total meat used

% Constraints

% Tooth medication availability constraint
constraint
  tooth_per_small * small_bones + tooth_per_large * large_bones
  <= tooth_med_available;

% Minimum number of large bones
constraint
  large_bones >= min_large_bones;

% At least 50% of all bones must be small
% small_bones / (small_bones + large_bones) >= min_small_fraction
% Cross-multiply (and use floats) to avoid division and keep types consistent:
constraint
  (1.0 - min_small_fraction) * int2float(small_bones)
  >= min_small_fraction * int2float(large_bones);

% Define total meat used
constraint
  total_meat = meat_per_small * small_bones + meat_per_large * large_bones;

% Objective
solve minimize total_meat;