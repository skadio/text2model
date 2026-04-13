% Parameters
% All data are embedded directly in the model as per instructions.
int: min_total_units = 300;      % minimum combined investment units (TV + Radio)
int: max_total_units = 1000;     % maximum combined investment units (TV + Radio)
int: min_diff_tv_radio = 100;    % minimum required difference: TV - Radio >= 100
int: cost_tv = 200;              % cost per unit of TV investment (dollars)
int: cost_radio = 500;           % cost per unit of Radio investment (dollars)

% Variables
var 0..max_total_units: tv_units;       % integer units invested in TV ads
var 0..max_total_units: radio_units;    % integer units invested in Radio ads
var 0..(max_total_units * max(cost_tv, cost_radio)): total_cost; % total cost (dollars)

% Constraints
% Combined investment units must satisfy minimum exposure and maximum budgeted units
constraint tv_units + radio_units >= min_total_units;
constraint tv_units + radio_units <= max_total_units;

% TV investment must exceed Radio investment by at least the required difference
constraint tv_units - radio_units >= min_diff_tv_radio;

% Define total cost from unit investments and per-unit costs
constraint total_cost = cost_tv * tv_units + cost_radio * radio_units;

% Objective
solve minimize total_cost;