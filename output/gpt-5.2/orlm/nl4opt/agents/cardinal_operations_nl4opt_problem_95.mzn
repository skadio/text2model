% Parameters
int: total_tooth_med = 2000;              % Total available tooth medication units

int: tooth_per_small = 10;                % Tooth medication per small bone
int: meat_per_small  = 12;                % Meat per small bone

int: tooth_per_large = 15;                % Tooth medication per large bone
int: meat_per_large  = 15;                % Meat per large bone

int: min_large_bones = 30;                % Minimum required number of large bones

% Variables
% Upper bounds derived from tooth medication limit (and integrality)
int: max_small = total_tooth_med div tooth_per_small;  % <= 200
int: max_large = total_tooth_med div tooth_per_large;  % <= 133

var 0..max_small: small_bones;            % Number of small bones to produce
var 0..max_large: large_bones;            % Number of large bones to produce

var 0..(meat_per_small*max_small + meat_per_large*max_large): total_meat;
                                          % Total meat used (objective variable)

% Constraints
% Tooth medication capacity constraint
constraint
  tooth_per_small * small_bones + tooth_per_large * large_bones <= total_tooth_med;

% Minimum production of large bones
constraint
  large_bones >= min_large_bones;

% Preference constraint: at least 50% of all bones are small
% small_bones / (small_bones + large_bones) >= 0.5  <=>  2*small_bones >= small_bones + large_bones
constraint
  small_bones >= large_bones;

% Define total meat usage based on production quantities
constraint
  total_meat = meat_per_small * small_bones + meat_per_large * large_bones;

% Objective
solve minimize total_meat;