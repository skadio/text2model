% Parameters
% Minimum total hires required across departments
int: min_total_hires = 10;

% Maximum allowed for (2 * hires in X + hires in Y)
int: max_weighted_staff = 20;

% Onboarding cost per hire in each department (dollars)
int: cost_x = 50;
int: cost_y = 30;

% Variables
% Number of new hires in department X (whole people)
var 0..max_weighted_staff: hires_x;

% Number of new hires in department Y (whole people)
var 0..max_weighted_staff: hires_y;

% Total onboarding cost (bounded using max_weighted_staff as a safe upper bound)
var 0..(max_weighted_staff * (cost_x + cost_y)): total_cost;

% Constraints
% Staffing requirement: total hires across both departments must meet minimum
constraint hires_x + hires_y >= min_total_hires;

% Budget/space limitation: weighted staffing must not exceed maximum
constraint 2 * hires_x + hires_y <= max_weighted_staff;

% Cost definition: compute total onboarding cost from hires in each department
constraint total_cost = cost_x * hires_x + cost_y * hires_y;

% Objective
solve minimize total_cost;