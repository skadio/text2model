% Parameters
int: cost_wheat = 20;        % cost per acre for wheat
int: cost_corn = 30;         % cost per acre for corn
int: cost_soybeans = 10;     % cost per acre for soybeans

int: max_wheat_corn = 200;   % maximum combined acres of wheat and corn
int: min_rotation = 150;     % minimum required for (2*wheat + soybeans)
int: max_diff = 100;         % maximum allowed absolute difference between corn and soybeans


% Variables
var 0..max_wheat_corn: acres_wheat;      % acres planted with wheat (non-negative integer)
var 0..max_wheat_corn: acres_corn;       % acres planted with corn (non-negative integer)
var 0..(2*min_rotation): acres_soybeans; % acres planted with soybeans (non-negative integer)

% Upper bound is a safe over-approximation for total planting cost
var 0..(cost_wheat*max_wheat_corn + cost_corn*max_wheat_corn + cost_soybeans*(2*min_rotation)): total_cost;


% Constraints
% Land capacity: wheat + corn cannot exceed the available combined acreage
constraint acres_wheat + acres_corn <= max_wheat_corn;

% Crop rotation requirement: twice wheat plus soybeans must meet minimum rotation threshold
constraint 2 * acres_wheat + acres_soybeans >= min_rotation;

% Balance requirement: corn and soybeans acreage difference limited by max_diff
constraint abs(acres_corn - acres_soybeans) <= max_diff;

% Define total cost based on per-acre planting costs
constraint total_cost =
  cost_wheat * acres_wheat +
  cost_corn * acres_corn +
  cost_soybeans * acres_soybeans;


% Objective
solve minimize total_cost;