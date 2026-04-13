% Parameters

% Channel index set
set of int: CHANNELS = 1..4;

% Named indices for readability
int: TV = 1;
int: RADIO = 2;
int: SOCIAL = 3;
int: OUTDOOR = 4;

% Cost per unit effectiveness (in thousands) for each channel
array[CHANNELS] of float: cost_per_unit = [0.5, 0.6, 0.8, 1.2];

% Maximum allocation bounds for each channel (units)
array[CHANNELS] of int: max_alloc = [700, 600, 500, 400];

% Problem constants from the description
int: min_tv_radio = 500;          % TV + Radio >= 500
int: max_diff_social_radio = 200; % |Social - Radio| <= 200
int: min_outdoor_over_tv = 100;   % Outdoor >= TV + 100
int: max_social_outdoor = 800;    % Social + Outdoor <= 800


% Variables

% Integer budget allocations per channel (whole numbers).
% Use a safe temporary upper bound and tighten via max_alloc constraints.
array[CHANNELS] of var 0..700: alloc;

% Total cost (in thousands)
var float: total_cost;


% Constraints

% --- Allocation domain tightening (channel-specific maximum bounds) ---
constraint
  forall(c in CHANNELS) (
    alloc[c] <= max_alloc[c]
  );

% --- Minimum combined allocation for TV and Radio (reach requirement) ---
constraint
  alloc[TV] + alloc[RADIO] >= min_tv_radio;

% --- Balanced mix: Social Media and Radio budgets must be close ---
constraint
  abs(alloc[SOCIAL] - alloc[RADIO]) <= max_diff_social_radio;

% --- Outdoor visibility strategy: Outdoor must exceed TV by at least 100 ---
constraint
  alloc[OUTDOOR] >= alloc[TV] + min_outdoor_over_tv;

% --- Resource limit: Social Media + Outdoor cannot exceed 800 ---
constraint
  alloc[SOCIAL] + alloc[OUTDOOR] <= max_social_outdoor;

% --- Total cost definition (ensure consistent float typing) ---
constraint
  total_cost =
    sum(c in CHANNELS) (cost_per_unit[c] * int2float(alloc[c]));


% Objective
solve minimize total_cost;