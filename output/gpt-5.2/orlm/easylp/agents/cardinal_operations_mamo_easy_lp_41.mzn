% Parameters
int: budget = 10000;                 % Maximum total amount available to invest ($)
int: min_invest_X = 2000;            % Minimum amount to invest in option X ($)
int: min_invest_Y = 3000;            % Minimum amount to invest in option Y ($)
float: cost_per_dollar_X = 0.02;     % Cost per invested dollar in option X ($ per $)
float: cost_per_dollar_Y = 0.03;     % Cost per invested dollar in option Y ($ per $)

% Variables
var min_invest_X..budget: invest_X;  % Amount invested in option X ($), integer
var min_invest_Y..budget: invest_Y;  % Amount invested in option Y ($), integer
var float: total_cost;               % Total cost ($)

% Constraints
% Budget feasibility: total investment cannot exceed available budget
constraint invest_X + invest_Y <= budget;

% Minimum investment requirements for diversification
constraint invest_X >= min_invest_X;
constraint invest_Y >= min_invest_Y;

% Total cost computation from per-dollar costs (cast ints to float)
constraint total_cost = cost_per_dollar_X * float(invest_X)
                      + cost_per_dollar_Y * float(invest_Y);

% Objective
solve minimize total_cost;