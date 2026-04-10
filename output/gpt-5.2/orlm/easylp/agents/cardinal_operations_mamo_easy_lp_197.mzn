% Parameters
int: total_budget = 50000;              % Maximum total dollars allocated across X, Y, Z
int: min_diff_XY = 10000;               % X must be at least this much more than Y
int: min_diff_YZ = 5000;                % Y must be at least this much more than Z

int: cost_per_dollar_X = 1000;          % Cost incurred per dollar invested in X
int: cost_per_dollar_Y = 800;           % Cost incurred per dollar invested in Y
int: cost_per_dollar_Z = 600;           % Cost incurred per dollar invested in Z

% Variables
var 0..total_budget: invest_X;          % Whole-dollar investment in portfolio X
var 0..total_budget: invest_Y;          % Whole-dollar investment in portfolio Y
var 0..total_budget: invest_Z;          % Whole-dollar investment in portfolio Z

% Total cost to minimize (upper bound is worst-case if entire budget spent in each, though budget constraint prevents that)
var 0..(cost_per_dollar_X*total_budget
      + cost_per_dollar_Y*total_budget
      + cost_per_dollar_Z*total_budget): total_cost;

% Constraints

% Budget feasibility: total allocated across portfolios cannot exceed available budget
constraint invest_X + invest_Y + invest_Z <= total_budget;

% Relative allocation requirements between portfolios
constraint invest_X >= invest_Y + min_diff_XY;   % X at least min_diff_XY more than Y
constraint invest_Y >= invest_Z + min_diff_YZ;   % Y at least min_diff_YZ more than Z

% Define total cost based on per-dollar costs in each portfolio
constraint total_cost = cost_per_dollar_X * invest_X
                      + cost_per_dollar_Y * invest_Y
                      + cost_per_dollar_Z * invest_Z;

% Objective
solve minimize total_cost;