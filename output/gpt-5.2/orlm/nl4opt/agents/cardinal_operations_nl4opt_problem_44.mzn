% Parameters
int: vintage_ml = 500;          % ml capacity of a vintage bottle
int: regular_ml = 750;          % ml capacity of a regular bottle
int: total_ml   = 100000;       % total available ml of wine
int: min_vintage = 10;          % minimum number of vintage bottles
int: regular_to_vintage = 4;    % regular bottles must be at least this multiple of vintage

% Variables
var min_vintage..(total_ml div vintage_ml): nVintage;  % number of vintage bottles
var 0..(total_ml div regular_ml): nRegular;            % number of regular bottles

% Constraints
% Total wine usage must not exceed available wine
constraint
  vintage_ml * nVintage + regular_ml * nRegular <= total_ml;

% Demand rule: regular bottles must be at least 4 times the vintage bottles
constraint
  nRegular >= regular_to_vintage * nVintage;

% Objective
solve maximize (nVintage + nRegular);