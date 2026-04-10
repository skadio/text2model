% Parameters
int: total_budget = 5000;          % Maximum total dollars allocated across X,Y,Z
int: min_invest_X = 1000;          % Minimum dollars required for project X
int: max_invest_Y = 3000;          % Maximum dollars allowed for project Y
int: min_invest_Z = 500;           % Minimum dollars required for project Z

int: unit_cost_X = 100;            % Cost per $1 invested in X
int: unit_cost_Y = 200;            % Cost per $1 invested in Y
int: unit_cost_Z = 50;             % Cost per $1 invested in Z

% Variables
var 0..total_budget: invest_X;     % Dollars allocated to project X
var 0..total_budget: invest_Y;     % Dollars allocated to project Y
var 0..total_budget: invest_Z;     % Dollars allocated to project Z

% Total cost in dollars (bounded using worst-case upper bound)
var 0..(unit_cost_X*total_budget + unit_cost_Y*total_budget + unit_cost_Z*total_budget): total_cost;

% Constraints
% --- Budget feasibility constraint ---
constraint invest_X + invest_Y + invest_Z <= total_budget;

% --- Project-specific investment bounds ---
constraint invest_X >= min_invest_X;   % X minimum
constraint invest_Y <= max_invest_Y;   % Y maximum
constraint invest_Z >= min_invest_Z;   % Z minimum

% --- Total cost definition ---
constraint total_cost =
  unit_cost_X * invest_X +
  unit_cost_Y * invest_Y +
  unit_cost_Z * invest_Z;

% Objective
solve minimize total_cost;