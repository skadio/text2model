% Parameters
int: mg_per_gummy = 3;          % magnesium units per gummy
int: zn_per_gummy = 4;          % zinc units per gummy
int: mg_per_pill  = 2;          % magnesium units per pill
int: zn_per_pill  = 5;          % zinc units per pill

int: min_pills = 10;            % minimum number of pills to take
int: gummy_to_pill_ratio = 3;   % gummies must be at least this times pills
int: max_magnesium = 200;       % maximum total magnesium allowed

% Variables
var 0..max_magnesium: gummies;  % number of gummies eaten
var 0..max_magnesium: pills;    % number of pills taken

% Constraints
% Minimum pills requirement
constraint pills >= min_pills;

% Preference requirement: gummies must be at least gummy_to_pill_ratio times pills
constraint gummies >= gummy_to_pill_ratio * pills;

% Magnesium consumption must not exceed max_magnesium
constraint mg_per_gummy * gummies + mg_per_pill * pills <= max_magnesium;

% Objective
solve maximize (zn_per_gummy * gummies + zn_per_pill * pills);