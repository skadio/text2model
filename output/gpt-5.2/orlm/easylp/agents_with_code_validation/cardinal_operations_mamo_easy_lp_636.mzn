% Parameters
% Promotion cost per unit allocated to each attraction
int: cost_x1 = 300; % local culture
int: cost_x2 = 200; % natural beauty
int: cost_x3 = 100; % historical sites
int: cost_x4 = 50;  % adventure activities

% Constraint constants
int: cap_x1_x2 = 500;          % x1 + x2 <= 500
int: min_vis_2x1_3p5x3 = 700;  % 2*x1 + 3.5*x3 >= 700
int: bal_limit = 300;          % x2 - 0.5*x3 - x1 <= 300
int: pref_limit = 400;         % 0.5*x4 - x2 <= 400
int: policy_offset = 150;      % x4 <= x1 - 150


% Variables
% Resource allocations (whole numbers)
var int: x1; % local culture
var int: x2; % natural beauty
var int: x3; % historical sites
var int: x4; % adventure activities

% Total promotional cost (integer)
var int: total_cost;


% Constraints
% --- Non-negativity (resource allocations are whole numbers, cannot be negative)
constraint
  x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% --- Budget/capacity: combined allocation for x1 and x2 cannot exceed cap
constraint
  x1 + x2 <= cap_x1_x2;

% --- Minimum visibility: 2*x1 + 3.5*x3 >= 700
% Multiply by 2 to avoid fractions: 4*x1 + 7*x3 >= 2*700
constraint
  4*x1 + 7*x3 >= 2 * min_vis_2x1_3p5x3;

% --- Balanced promotions: x2 - 0.5*x3 - x1 <= 300
% Multiply by 2 to avoid fractions: 2*x2 - x3 - 2*x1 <= 2*300
constraint
  2*x2 - x3 - 2*x1 <= 2 * bal_limit;

% --- Preference constraint: 0.5*x4 - x2 <= 400
% Multiply by 2 to avoid fractions: x4 - 2*x2 <= 2*400
constraint
  x4 - 2*x2 <= 2 * pref_limit;

% --- Operational policy: x4 <= x1 - 150
constraint
  x4 <= x1 - policy_offset;

% --- Total cost definition
constraint
  total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;


% Objective
solve minimize total_cost;