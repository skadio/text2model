% Parameters
% Total budget limit (in dollars)
int: maxBudget = 1000;

% Minimum spending differences (in dollars)
int: minDiff_XY = 100;   % X >= Y + 100
int: minDiff_YZ = 50;    % Y >= Z + 50

% Returns per dollar spent (units of return per $)
int: returnPerDollar_X = 10;
int: returnPerDollar_Y = 15;
int: returnPerDollar_Z = 20;


% Variables
% Budget allocations (whole dollars)
var 0..maxBudget: budgetX;
var 0..maxBudget: budgetY;
var 0..maxBudget: budgetZ;

% Total return (units)
var 0..(maxBudget * max(returnPerDollar_X, max(returnPerDollar_Y, returnPerDollar_Z))): totalReturn;


% Constraints
% Budget feasibility: total allocation cannot exceed the maximum budget
constraint budgetX + budgetY + budgetZ <= maxBudget;

% Minimum difference constraints between campaign budgets
constraint budgetX >= budgetY + minDiff_XY;  % X requires at least $100 more than Y
constraint budgetY >= budgetZ + minDiff_YZ;  % Y requires at least $50 more than Z

% Total return calculation based on per-dollar returns
constraint
  totalReturn =
    returnPerDollar_X * budgetX +
    returnPerDollar_Y * budgetY +
    returnPerDollar_Z * budgetZ;


% Objective
solve minimize totalReturn;