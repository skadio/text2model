% Parameters
int: manual_slices_per_min = 5;        % slices/min produced by one manual slicer
int: automatic_slices_per_min = 8;     % slices/min produced by one automatic slicer

int: manual_grease_per_min = 3;        % grease units/min required by one manual slicer
int: automatic_grease_per_min = 6;     % grease units/min required by one automatic slicer

int: min_slices_required = 50;         % minimum total slices/min required
int: max_grease_allowed = 35;          % maximum total grease units/min allowed

% Useful bounds (derived from constraints) to keep variables bounded
int: max_manual = max_grease_allowed div manual_grease_per_min;        % floor(35/3) = 11
int: max_automatic = max_grease_allowed div automatic_grease_per_min;  % floor(35/6) = 5


% Variables
var 0..max_manual: manual_slicers;       % number of manual slicers to buy
var 0..max_automatic: automatic_slicers; % number of automatic slicers to buy

var 0..(max_manual + max_automatic): total_slicers; % total slicers (objective)


% Constraints

% Total slicers definition
constraint total_slicers = manual_slicers + automatic_slicers;

% Production requirement: achieve at least the minimum slices per minute
constraint
  manual_slices_per_min * manual_slicers +
  automatic_slices_per_min * automatic_slicers
  >= min_slices_required;

% Grease usage limit: stay within the maximum grease per minute
constraint
  manual_grease_per_min * manual_slicers +
  automatic_grease_per_min * automatic_slicers
  <= max_grease_allowed;

% Staffing/operation rule: manual slicers must be fewer than automatic slicers
constraint manual_slicers < automatic_slicers;


% Objective
solve minimize total_slicers;