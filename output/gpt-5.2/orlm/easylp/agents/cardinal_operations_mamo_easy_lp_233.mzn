% Parameters
int: cost_wheat   = 10;   % cost per acre for wheat
int: cost_corn    = 15;   % cost per acre for corn
int: cost_soybean = 20;   % cost per acre for soybean

int: max_wheat   = 400;   % upper bound (acres) for wheat
int: max_corn    = 200;   % upper bound (acres) for corn
int: max_soybean = 300;   % upper bound (acres) for soybean

int: limit_2w_plus_c = 500; % constraint: 2*wheat + corn <= 500
int: min_w_plus_s    = 300; % constraint: wheat + soybean >= 300
int: max_diff_c_s    = 100; % constraint: |corn - soybean| <= 100

% Variables
var 0..max_wheat:   acres_wheat;   % acres planted with wheat (integer acres)
var 0..max_corn:    acres_corn;    % acres planted with corn (integer acres)
var 0..max_soybean: acres_soybean; % acres planted with soybean (integer acres)

var 0..(cost_wheat*max_wheat + cost_corn*max_corn + cost_soybean*max_soybean): total_cost;
% total planting cost (bounded above by max possible cost)

% Constraints

% Link total cost to planted acres and per-acre costs
constraint total_cost =
  cost_wheat   * acres_wheat +
  cost_corn    * acres_corn +
  cost_soybean * acres_soybean;

% Land-use constraint: twice wheat plus corn cannot exceed the specified limit
constraint 2 * acres_wheat + acres_corn <= limit_2w_plus_c;

% Minimum planting requirement: wheat plus soybean must be at least the specified minimum
constraint acres_wheat + acres_soybean >= min_w_plus_s;

% Balance constraint: corn and soybean areas must differ by no more than the specified maximum
constraint abs(acres_corn - acres_soybean) <= max_diff_c_s;

% Objective
solve minimize total_cost;