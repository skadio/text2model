% Parameters
% Total budget limit (in dollars)
int: total_budget = 5000;

% Minimum gap between X and Y (X at least this much more than Y)
int: min_gap_XY = 50;

% Difference limits between Z and X, and between Z and Y
int: max_diff_ZX = 1000;
int: max_diff_ZY = 200;

% Cost per unit impact (treated as dollars per unit invested)
int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 1000;

% Maximum investment per channel (in dollars)
int: max_X = 2500;
int: max_Y = 1500;
int: max_Z = 4000;

% Variables
% Amount invested in each channel (whole dollars)
var 0..max_X: invest_X;
var 0..max_Y: invest_Y;
var 0..max_Z: invest_Z;

% Total cost to minimize (in dollars)
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
% Budget feasibility: total invested across all channels must not exceed the total budget
constraint
  invest_X + invest_Y + invest_Z <= total_budget;

% Channel dominance: X investment must be at least min_gap_XY dollars more than Y
constraint
  invest_X >= invest_Y + min_gap_XY;

% Strategic proximity constraints: keep Z close enough to X and Y (absolute differences bounded)
constraint
  abs(invest_Z - invest_X) <= max_diff_ZX;

constraint
  abs(invest_Z - invest_Y) <= max_diff_ZY;

% Define total_cost consistently from per-channel investments and per-unit costs
constraint
  total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;