% Parameters
int: max_total_tourists = 50;                 % Capacity limit for total tourists

int: cost_X = 150;                           % Cost per tourist in package X
int: cost_Y = 200;                           % Cost per tourist in package Y
int: cost_Z = 100;                           % Cost per tourist in package Z

int: min_efficiency = 60;                    % Minimum required weighted sum: 2X + 3Y + Z
int: max_diff_YZ = 10;                       % Maximum allowed difference between Y and Z

% Variables
var 0..max_total_tourists: tourists_X;        % Number of tourists assigned to package X
var 0..max_total_tourists: tourists_Y;        % Number of tourists assigned to package Y
var 0..max_total_tourists: tourists_Z;        % Number of tourists assigned to package Z

% Upper bound: all 50 tourists assigned to the most expensive package
var 0..(max_total_tourists * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
% Capacity constraint: total tourists cannot exceed the maximum capacity
constraint
  tourists_X + tourists_Y + tourists_Z <= max_total_tourists;

% Minimum efficiency constraint: weighted sum must meet or exceed required minimum
constraint
  2 * tourists_X + 3 * tourists_Y + tourists_Z >= min_efficiency;

% Balance constraint between packages Y and Z: absolute difference cannot exceed max_diff_YZ
constraint
  abs(tourists_Y - tourists_Z) <= max_diff_YZ;

% Total cost definition: link total_cost to the per-package costs and allocations
constraint
  total_cost = cost_X * tourists_X + cost_Y * tourists_Y + cost_Z * tourists_Z;

% Objective
solve minimize total_cost;