% Parameters
% Cost per unit at each distribution center
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 150;
int: cost_x4 = 250;

% Upper bounds for allocations
int: max_x1 = 5000;
int: max_x2 = 5000;
int: max_x3 = 6000;
int: max_x4 = 6000;

% Pairwise capacity/budget limits and minimum requirements
int: cap_12 = 5000;   % x1 + x2 <= cap_12
int: cap_34 = 6000;   % x3 + x4 <= cap_34
int: min_13 = 3000;   % x1 + x3 >= min_13
int: min_24 = 4000;   % x2 + x4 >= min_24


% Variables
% Integer allocations to centers (whole numbers)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Total cost (bounded by maximum possible cost)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% --- Pairwise capacity (upper-bound) constraints ---
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

% --- Pairwise minimum allocation (lower-bound) constraints ---
constraint x1 + x3 >= min_13;
constraint x2 + x4 >= min_24;

% --- Total cost definition constraint ---
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;


% Objective
solve minimize total_cost;