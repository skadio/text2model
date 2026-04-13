% Parameters
% Total available budget (maximum combined allocation)
int: total_budget = 1000;

% Minimum required allocations for each campaign
int: min_X = 200;
int: min_Y = 100;
int: min_Z = 50;

% Cost per unit allocated to each campaign
int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 4;

% Variables
% Integer allocations (whole-number units) to each campaign
var min_X..total_budget: alloc_X;
var min_Y..total_budget: alloc_Y;
var min_Z..total_budget: alloc_Z;

% Total cost (bounded using known allocation bounds)
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
% Budget feasibility: total allocation cannot exceed the available budget
constraint
  alloc_X + alloc_Y + alloc_Z <= total_budget;

% Minimum requirements (also enforced by variable domains)
constraint
  alloc_X >= min_X /\ alloc_Y >= min_Y /\ alloc_Z >= min_Z;

% Total cost definition
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;