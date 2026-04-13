% Parameters
int: total_budget = 50000;           % Maximum total allocation across X, Y, Z (in dollars)
int: min_diff_XY = 10000;            % X must be at least this much more than Y (in dollars)
int: min_diff_YZ = 5000;             % Y must be at least this much more than Z (in dollars)

int: cost_X = 1000;                  % Cost per dollar invested in X
int: cost_Y = 800;                   % Cost per dollar invested in Y
int: cost_Z = 600;                   % Cost per dollar invested in Z

% Variables
var 0..total_budget: invest_X;        % Dollars allocated to portfolio X (integer dollars)
var 0..total_budget: invest_Y;        % Dollars allocated to portfolio Y (integer dollars)
var 0..total_budget: invest_Z;        % Dollars allocated to portfolio Z (integer dollars)

% Upper bound on total cost if all budget were (hypothetically) spent in each portfolio
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
% Budget limit: total allocation across all portfolios cannot exceed the total budget
constraint invest_X + invest_Y + invest_Z <= total_budget;

% Minimum difference constraints between portfolio allocations
constraint invest_X >= invest_Y + min_diff_XY;   % X at least min_diff_XY more than Y
constraint invest_Y >= invest_Z + min_diff_YZ;   % Y at least min_diff_YZ more than Z

% Total cost definition
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;