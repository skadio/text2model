% Parameters
int: cost_x1 = 200;   % Unit cost of promoting destination x1
int: cost_x2 = 150;   % Unit cost of promoting destination x2
int: cost_x3 = 100;   % Unit cost of promoting destination x3
int: cost_x4 = 50;    % Unit cost of promoting destination x4

int: max_x1_x2 = 300; % Upper bound on combined allocation to x1 and x2
int: max_x3_x4 = 200; % Upper bound on combined allocation to x3 and x4
int: min_x1_x3 = 150; % Lower bound on combined allocation to x1 and x3
int: min_x2_x4 = 150; % Lower bound on combined allocation to x2 and x4

% Variables
var 0..max_x1_x2: x1; % Resource allocation to destination x1 (non-negative integer)
var 0..max_x1_x2: x2; % Resource allocation to destination x2 (non-negative integer)
var 0..max_x3_x4: x3; % Resource allocation to destination x3 (non-negative integer)
var 0..max_x3_x4: x4; % Resource allocation to destination x4 (non-negative integer)

% Total cost (upper bound computed from variable domains and unit costs)
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;

% Constraints
% Budget/upper-bound constraints on paired allocations
constraint x1 + x2 <= max_x1_x2;  % Combined allocation to x1 and x2 cannot exceed 300
constraint x3 + x4 <= max_x3_x4;  % Combined allocation to x3 and x4 cannot exceed 200

% Minimum coverage/lower-bound constraints on cross-paired allocations
constraint x1 + x3 >= min_x1_x3;  % At least 150 units allocated collectively to x1 and x3
constraint x2 + x4 >= min_x2_x4;  % At least 150 units allocated collectively to x2 and x4

% Total cost calculation (linking decision variables to total_cost)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;