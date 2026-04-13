% Parameters
% Total available budget across all campaigns
int: total_budget = 1000;

% Maximum allocations (upper bounds) for each campaign
int: max_x = 500;
int: max_y = 400;
int: max_z = 600;

% Constraint constants
int: z_minus_three_quarters_x_limit = 150;   % |Z - 3/4 X| <= 150 (implemented via linear inequalities)
int: y_at_least_z_plus = 50;                 % Y >= Z + 50

% Cost per unit effectiveness for each campaign
int: cost_x = 100;
int: cost_y = 200;
int: cost_z = 300;


% Variables
% Budget allocated to each campaign (integer units)
var 0..max_x: budget_x;
var 0..max_y: budget_y;
var 0..max_z: budget_z;

% Total cost to be minimized (integer)
var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;


% Constraints
%----------------------------
% Budget limit across campaigns
%----------------------------
constraint
  budget_x + budget_y + budget_z <= total_budget;

%----------------------------
% Relative allocation constraints
%----------------------------

% Campaign X should not be less than half of campaign Y: X >= Y/2  <=>  2X >= Y
constraint
  2 * budget_x >= budget_y;

% Campaign Y should receive at least 50 more units than campaign Z: Y >= Z + 50
constraint
  budget_y >= budget_z + y_at_least_z_plus;

%----------------------------
% Difference constraint: |Z - (3/4)X| <= 150
% Implemented without fractions: |4Z - 3X| <= 600
%----------------------------
constraint
  4 * budget_z - 3 * budget_x <= 4 * z_minus_three_quarters_x_limit;

constraint
  3 * budget_x - 4 * budget_z <= 4 * z_minus_three_quarters_x_limit;

%----------------------------
% Total cost definition
%----------------------------
constraint
  total_cost = cost_x * budget_x + cost_y * budget_y + cost_z * budget_z;


% Objective
solve minimize total_cost;