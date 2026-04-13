% Parameters
int: max_total_budget = 5000;          % Upper limit on total allocated budget (units)
int: reach_target = 2000;              % Minimum required reach points

int: aX = 5;                           % Reach coefficient for campaign X
int: aY = -3;                          % Reach coefficient for campaign Y
int: aZ = 1;                           % Reach coefficient for campaign Z

int: yz_extra_limit = 1000;            % Extra allowance in X+Z vs 2*Y constraint

int: costX = 100;                      % Cost per unit budget for X (dollars)
int: costY = 50;                       % Cost per unit budget for Y (dollars)
int: costZ = 20;                       % Cost per unit budget for Z (dollars)

% Variables
var 0..max_total_budget: budgetX;      % Budget allocated to campaign X (integer units)
var 0..max_total_budget: budgetY;      % Budget allocated to campaign Y (integer units)
var 0..max_total_budget: budgetZ;      % Budget allocated to campaign Z (integer units)

var 0..(costX*max_total_budget + costY*max_total_budget + costZ*max_total_budget): total_cost;
                                       % Total cost to minimize (dollars, integer)

% (Optional) Derived expressions as variables, bounded explicitly for linear safety
var -3*max_total_budget .. 5*max_total_budget + max_total_budget: reach_points;
                                       % Reach points from the allocation

var -2*max_total_budget .. 2*max_total_budget: balance_lhs;
                                       % LHS of (X+Z - 2*Y) for the spending-balance constraint

% Constraints

%-------------------------------
% Budget feasibility constraints
%-------------------------------
constraint
  % Total allocated budget cannot exceed the available budget cap
  budgetX + budgetY + budgetZ <= max_total_budget;

%-------------------------------
% Reach computation and target
%-------------------------------
constraint
  % Define reach points based on campaign coefficients
  reach_points = aX * budgetX + aY * budgetY + aZ * budgetZ;

constraint
  % Enforce minimum required reach points
  reach_points >= reach_target;

%-----------------------------------------
% Spending-balance (X+Z vs 2*Y) constraint
%-----------------------------------------
constraint
  % Define LHS of balance constraint for clarity: (X + Z - 2*Y)
  balance_lhs = budgetX + budgetZ - 2 * budgetY;

constraint
  % X+Z cannot exceed 2*Y by more than the extra allowance
  balance_lhs <= yz_extra_limit;

%-------------------------------
% Total cost computation
%-------------------------------
constraint
  % Define total cost from per-unit campaign costs
  total_cost = costX * budgetX + costY * budgetY + costZ * budgetZ;

% Objective
solve minimize total_cost;