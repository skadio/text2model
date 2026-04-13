% Parameters
% Land capacity limits
int: max_wheat_corn = 50;          % Maximum combined units of wheat + corn
int: max_rice_soybean = 30;        % Maximum combined units of rice + soybean

% Minimum soil-health (rotation) requirements
int: min_wheat_rice = 20;          % Minimum combined units of wheat + rice
int: min_corn_soybean = 15;        % Minimum combined units of corn + soybean

% Unit planting costs (dollars per unit)
int: cost_wheat = 4;
int: cost_corn = 3;
int: cost_rice = 2;
int: cost_soybean = 1;

% Variables
var 0..max_wheat_corn: wheat;      % Units of wheat planted (integer)
var 0..max_wheat_corn: corn;       % Units of corn planted (integer)
var 0..max_rice_soybean: rice;     % Units of rice planted (integer)
var 0..max_rice_soybean: soybean;  % Units of soybean planted (integer)

% Upper bound is a safe (loose) bound based on variable maxima
var 0..(cost_wheat*max_wheat_corn
      + cost_corn*max_wheat_corn
      + cost_rice*max_rice_soybean
      + cost_soybean*max_rice_soybean): total_cost;

% Constraints
% Land capacity limits
constraint wheat + corn <= max_wheat_corn;          % Combined wheat + corn cannot exceed available land
constraint rice + soybean <= max_rice_soybean;      % Combined rice + soybean cannot exceed available land

% Minimum soil-health (rotation) requirements
constraint wheat + rice >= min_wheat_rice;          % Must plant at least this many units of wheat + rice
constraint corn + soybean >= min_corn_soybean;      % Must plant at least this many units of corn + soybean

% Total cost definition
constraint
  total_cost = cost_wheat * wheat
             + cost_corn * corn
             + cost_rice * rice
             + cost_soybean * soybean;

% Objective
solve minimize total_cost;