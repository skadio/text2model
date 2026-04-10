% Parameters
% Maximum combined allocations (budget caps)
int: max_XY = 100;
int: max_ZW = 80;

% Minimum combined allocations (service balance requirements)
int: min_XZ = 50;
int: min_YW = 60;

% Per-unit costs (as floats)
float: cost_X = 0.2;
float: cost_Y = 0.3;
float: cost_Z = 0.1;
float: cost_W = 0.4;

% Variables
% Whole-number resource allocations to each department (non-negative)
var 0..max_XY: X;  % allocation to department X (bounded by XY cap)
var 0..max_XY: Y;  % allocation to department Y (bounded by XY cap)
var 0..max_ZW: Z;  % allocation to department Z (bounded by ZW cap)
var 0..max_ZW: W;  % allocation to department W (bounded by ZW cap)

% Total cost (explicitly bounded; max occurs at X=100,Y=100,Z=80,W=80)
var 0.0..(cost_X*max_XY + cost_Y*max_XY + cost_Z*max_ZW + cost_W*max_ZW): total_cost;

% Rounded-up (ceiling) total cost as an integer
var 0..ceil(cost_X*max_XY + cost_Y*max_XY + cost_Z*max_ZW + cost_W*max_ZW): total_cost_ceiled;

% Constraints
% Budget cap constraints (maximum combined allocations)
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

% Service balance constraints (minimum combined allocations)
constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

% Total cost definition (link integer allocations to float total_cost)
constraint
  total_cost = cost_X * int2float(X)
             + cost_Y * int2float(Y)
             + cost_Z * int2float(Z)
             + cost_W * int2float(W);

% Ceiling/round-up relationship between total_cost and integer total_cost_ceiled
% For total_cost_ceiled = 0, enforce total_cost = 0; otherwise enforce ceil behavior.
constraint
  (total_cost_ceiled = 0 -> total_cost = 0.0) /\
  (total_cost_ceiled > 0 -> int2float(total_cost_ceiled - 1) < total_cost);

constraint total_cost <= int2float(total_cost_ceiled);

% Objective
solve minimize total_cost_ceiled;