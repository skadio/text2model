% Parameters
% Unit costs per acre
int: cost_wheat   = 10;
int: cost_corn    = 20;
int: cost_soybean = 30;

% Pairwise acreage limits
int: max_wheat_corn    = 1000;  % Wheat + Corn <= 1000
int: max_corn_soybean  = 1500;  % Corn + Soybean <= 1500

% Minimum combined acreage
int: min_wheat_soybean = 500;   % Wheat + Soybean >= 500

% Rotation/difference requirement
int: min_wheat_over_corn = 200; % Wheat >= Corn + 200

% Acre bounds (chosen safe nonnegative bounds)
int: min_acres = 0;
int: max_acres = 2000;


% Variables
var min_acres..max_acres: acres_wheat;    % acres allocated to Wheat
var min_acres..max_acres: acres_corn;     % acres allocated to Corn
var min_acres..max_acres: acres_soybean;  % acres allocated to Soybean

var int: total_cost;                      % total cost (units)


% Constraints
% Pairwise acreage upper limits (land/market constraints)
constraint acres_wheat + acres_corn <= max_wheat_corn;
constraint acres_corn + acres_soybean <= max_corn_soybean;

% Minimum combined acreage requirement (demand/rotation constraint)
constraint acres_wheat + acres_soybean >= min_wheat_soybean;

% Rotation/difference requirement (wheat must exceed corn by at least a margin)
constraint acres_wheat >= acres_corn + min_wheat_over_corn;

% Total cost definition (linear cost aggregation)
constraint total_cost =
    cost_wheat * acres_wheat
  + cost_corn * acres_corn
  + cost_soybean * acres_soybean;


% Objective
solve minimize total_cost;

% Optional output
output [
  "acres_wheat=", show(acres_wheat), "\n",
  "acres_corn=", show(acres_corn), "\n",
  "acres_soybean=", show(acres_soybean), "\n",
  "total_cost=", show(total_cost), "\n"
];