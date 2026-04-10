% Parameters
% Unit costs for each allocation area
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

% Capacity limits
int: cap12 = 1000;        % Upper bound on x1 + x2
int: cap34 = 1200;        % Upper bound on x3 + x4

% Balance/gap constraint parameters
float: a1 = 0.7;          % Coefficient on x1
float: a2 = 0.8;          % Coefficient on x2
int: min_diff12 = 200;    % Minimum required: 0.7*x1 - 0.8*x2 >= 200
int: min_gap43 = 300;     % Minimum required: x4 - x3 >= 300


% Variables
% Integer allocations (non-negative)
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Total cost (float because costs are fractional)
var float: total_cost;


% Constraints
%--- Capacity constraints (pairwise allocation caps)
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

%--- Strategic balance constraint between areas 1 and 2
constraint a1 * x1 - a2 * x2 >= min_diff12;

%--- Minimum gap constraint between areas 4 and 3
constraint x4 - x3 >= min_gap43;

%--- Total cost definition (used by the objective)
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;