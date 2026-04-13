% Parameters
% Budget limit
int: budget = 1000;

% Strategic/regulatory constraint bounds
int: min_strategic = 200;   % X - 2Y + Z >= 200
int: max_balance   = 500;   % 2X + Y - Z <= 500

% Unit costs
int: costX = 50;
int: costY = 30;
int: costZ = 20;


% Variables
% Integer investments in each project (non-negative, bounded by budget)
var 0..budget: X;  % allocation to project X
var 0..budget: Y;  % allocation to project Y
var 0..budget: Z;  % allocation to project Z

% Total cost (bounded by max possible cost under budget)
var 0..(max([costX, costY, costZ]) * budget): total_cost;


% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint
  X + Y + Z <= budget;

% Strategic/regulatory constraint: X - 2Y + Z must meet minimum threshold
constraint
  X - 2 * Y + Z >= min_strategic;

% Balance constraint: 2X + Y - Z must not exceed maximum allowed
constraint
  2 * X + Y - Z <= max_balance;

% Total cost definition: compute total_cost from per-unit costs and allocations
constraint
  total_cost = costX * X + costY * Y + costZ * Z;


% Objective
solve minimize total_cost;