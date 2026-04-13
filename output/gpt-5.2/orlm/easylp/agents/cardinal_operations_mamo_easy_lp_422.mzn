% Parameters
% Unit costs (in dollars)
int: raw_unit_cost = 5;
int: labor_unit_cost = 10;

% Constraint constants
int: min_weighted_total = 20;        % minimum for 2*raw + 3*labor
int: max_difference = 30;            % |raw - labor| <= 30
int: fixed_total_allocation = 100;   % raw + labor == 100


% Variables
% Allocations (must be whole numbers)
var 0..fixed_total_allocation: raw_amount;     % units of raw materials
var 0..fixed_total_allocation: labor_amount;   % units of labor

% Total cost (bounded for safety)
var 0..(raw_unit_cost * fixed_total_allocation + labor_unit_cost * fixed_total_allocation): total_cost;


% Constraints
% Link total cost to allocations
constraint
  total_cost = raw_unit_cost * raw_amount + labor_unit_cost * labor_amount;

% Minimum weighted total requirement: 2*raw + 3*labor >= min_weighted_total
constraint
  2 * raw_amount + 3 * labor_amount >= min_weighted_total;

% Balance requirement: |raw - labor| <= max_difference
constraint
  abs(raw_amount - labor_amount) <= max_difference;

% Fixed total allocation: raw + labor == fixed_total_allocation
constraint
  raw_amount + labor_amount = fixed_total_allocation;


% Objective
solve minimize total_cost;