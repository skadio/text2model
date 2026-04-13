% Parameters
% Costs per unit investment
int: cost_residential = 300;
int: cost_commercial  = 200;
int: cost_industrial  = 500;

% ROI coefficients per unit investment
int: roi_residential = 5;
int: roi_commercial  = 3;
int: roi_industrial  = 10;

% Portfolio constraints
int: max_total_units = 50;     % x + y + z <= 50
int: min_total_roi   = 100;    % 5x + 3y + 10z >= 100


% Variables
var 0..max_total_units: x;  % number of residential units (integer, nonnegative)
var 0..max_total_units: y;  % number of commercial units (integer, nonnegative)
var 0..max_total_units: z;  % number of industrial units (integer, nonnegative)

% Derived quantities (bounded for propagation)
var 0..(max_total_units * max([cost_residential, cost_commercial, cost_industrial])): total_cost;
var 0..(max_total_units * max([roi_residential, roi_commercial, roi_industrial])): total_roi;


% Constraints
% --- Total units limit (portfolio size) ---
constraint x + y + z <= max_total_units;

% --- ROI definition and minimum requirement ---
constraint total_roi = roi_residential * x + roi_commercial * y + roi_industrial * z;
constraint total_roi >= min_total_roi;

% --- Preference/market condition: at least as many residential as commercial ---
constraint x >= y;

% --- Total cost definition ---
constraint total_cost = cost_residential * x + cost_commercial * y + cost_industrial * z;


% Objective
solve minimize total_cost;