% Parameters
int: cost_residential = 300;        % Cost per residential unit
int: cost_commercial  = 200;        % Cost per commercial unit
int: cost_industrial  = 500;        % Cost per industrial unit

int: max_total_units = 50;          % Maximum total units invested across all properties

int: roi_residential = 5;           % ROI contribution per residential unit
int: roi_commercial  = 3;           % ROI contribution per commercial unit
int: roi_industrial  = 10;          % ROI contribution per industrial unit
int: min_total_roi   = 100;         % Minimum required total ROI


% Variables
var 0..max_total_units: x;          % Number of residential units (integer, non-negative)
var 0..max_total_units: y;          % Number of commercial units (integer, non-negative)
var 0..max_total_units: z;          % Number of industrial units (integer, non-negative)

var 0..(max_total_units * max([cost_residential, cost_commercial, cost_industrial])): total_cost;
% Total investment cost (bounded using max unit cost)


% Constraints
% Total units constraint (cannot exceed maximum total units)
constraint x + y + z <= max_total_units;

% Minimum ROI requirement (must achieve at least the target ROI)
constraint roi_residential * x + roi_commercial * y + roi_industrial * z >= min_total_roi;

% Preference/market condition constraint: at least as many residential as commercial units
constraint x >= y;

% Define total_cost as the sum of costs across all property types
constraint total_cost = cost_residential * x + cost_commercial * y + cost_industrial * z;


% Objective
solve minimize total_cost;