% Parameters
% Maximum combined counts due to docking space and crew limits
int: max_x1_x2 = 1000;
int: max_x3_x4 = 1500;

% Operating cost per ship type
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;
int: cost_x4 = 80;

% Constant used in the x2 vs x4 relationship
int: x2_margin = 400;


% Variables
% Number of ships of each type (indivisible, so integer and non-negative)
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

% Total operating cost (explicitly bounded)
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;


% Constraints
% Docking space limitation for ship types x1 and x2
constraint x1 + x2 <= max_x1_x2;

% Crew availability limitation for ship types x3 and x4
constraint x3 + x4 <= max_x3_x4;

% Balance constraint: x1 must be at least twice half of x3 (i.e., x1 >= x3)
constraint x1 >= x3;

% Operational efficiency constraint:
% Interpreted as: x2 - (x4 / 2) <= x2_margin
% Avoid fractions by multiplying by 2: 2*x2 - x4 <= 2*x2_margin
constraint 2 * x2 - x4 <= 2 * x2_margin;

% Define total operating cost from ship counts and per-unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;