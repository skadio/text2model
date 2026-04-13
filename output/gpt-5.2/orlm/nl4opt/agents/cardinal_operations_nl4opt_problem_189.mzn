% Parameters
int: vitD_orange = 10;          % Vitamin D units per box of orange juice
int: vitC_orange = 8;           % Vitamin C units per box of orange juice
int: vitD_apple  = 12;          % Vitamin D units per box of apple juice
int: vitC_apple  = 6;           % Vitamin C units per box of apple juice

int: min_orange_boxes = 3;      % Must drink at least this many orange juice boxes
int: apple_to_orange_ratio = 3; % Must drink at least this many times as many apple boxes as orange
int: max_total_vitC = 300;      % Maximum allowed total vitamin C units

% Variables
var 0..max_total_vitC div vitC_orange: orange_boxes; % Number of orange juice boxes
var 0..max_total_vitC div vitC_apple:  apple_boxes;  % Number of apple juice boxes

% Constraints
% Minimum orange juice consumption
constraint orange_boxes >= min_orange_boxes;

% Preference constraint: at least apple_to_orange_ratio times as many apple boxes as orange boxes
constraint apple_boxes >= apple_to_orange_ratio * orange_boxes;

% Vitamin C overdose limit
constraint vitC_orange * orange_boxes + vitC_apple * apple_boxes <= max_total_vitC;

% Objective
solve maximize vitD_orange * orange_boxes + vitD_apple * apple_boxes;