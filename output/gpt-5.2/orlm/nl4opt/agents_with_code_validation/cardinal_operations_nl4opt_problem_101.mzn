% Parameters
int: water_per_subsoil_bag = 10;      % units of water per bag of subsoil per day
int: water_per_topsoil_bag  = 6;      % units of water per bag of topsoil per day
int: max_total_bags         = 150;    % truck capacity: total bags (subsoil + topsoil)
int: min_topsoil_bags       = 10;     % at least this many topsoil bags must be used
float: max_topsoil_fraction = 0.30;   % at most this fraction of all bags can be topsoil (kept for documentation)

% Variables
var 0..max_total_bags: subsoil_bags;  % number of subsoil bags to buy
var 0..max_total_bags: topsoil_bags;  % number of topsoil bags to buy
var 0..(water_per_subsoil_bag * max_total_bags): total_water; % total water required

% Constraints
% --- Total bags capacity (truck limit) ---
constraint
  subsoil_bags + topsoil_bags <= max_total_bags;

% --- Minimum topsoil requirement ---
constraint
  topsoil_bags >= min_topsoil_bags;

% --- Maximum fraction of topsoil (at most 30% of total bags) ---
% Use integer arithmetic to avoid float/int coercion:
% topsoil_bags <= 0.30 * (subsoil_bags + topsoil_bags)
% => 100*topsoil_bags <= 30*(subsoil_bags + topsoil_bags)
constraint
  100 * topsoil_bags <= 30 * (subsoil_bags + topsoil_bags);

% --- Total water definition ---
constraint
  total_water = water_per_subsoil_bag * subsoil_bags
              + water_per_topsoil_bag  * topsoil_bags;

% Objective
solve minimize total_water;