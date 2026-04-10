% Parameters
% Budget limit on total resources
int: budget = 1000;

% Minimum offset in the relationship between campaign X and Y
int: offset = 300;

% Unit costs for campaigns X and Y
int: costX = 4;
int: costY = 3;

% Variables
% Resources allocated to campaign X (whole units)
var 0..budget: x;

% Resources allocated to campaign Y (whole units)
var 0..budget: y;

% Total cost (bounded using max possible cost within budget)
var 0..max(costX, costY) * budget: total_cost;

% Constraints
% Total budget constraint: combined allocation cannot exceed the budget
constraint x + y <= budget;

% Demand relationship constraint: X must be at least twice Y plus an offset
constraint x >= 2 * y + offset;

% Total cost definition: compute total_cost from allocations and unit costs
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;