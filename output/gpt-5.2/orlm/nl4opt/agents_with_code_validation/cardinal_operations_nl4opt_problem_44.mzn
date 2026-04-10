% Parameters
int: vintage_ml = 500;              % ml capacity of a vintage bottle
int: regular_ml = 750;              % ml capacity of a regular bottle
int: total_ml = 100000;             % total ml of wine available
int: min_vintage = 10;              % minimum number of vintage bottles
int: regular_to_vintage_ratio = 4;  % regular bottles must be at least 4x vintage

% Variables
var min_vintage..(total_ml div vintage_ml): vintage_bottles;  % number of vintage bottles
var 0..(total_ml div regular_ml): regular_bottles;            % number of regular bottles

% Constraints
% Total wine used by both bottle types cannot exceed available wine
constraint
  vintage_ml * vintage_bottles + regular_ml * regular_bottles <= total_ml;

% Regular bottles must be at least 'regular_to_vintage_ratio' times the vintage bottles
constraint
  regular_bottles >= regular_to_vintage_ratio * vintage_bottles;

% Minimum vintage production (redundant with variable domain; kept for clarity)
constraint
  vintage_bottles >= min_vintage;

% Objective
solve maximize vintage_bottles + regular_bottles;