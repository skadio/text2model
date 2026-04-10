% Parameters
int: budget = 200000;                 % dollars
int: min_score = 400000;              % required minimum score (dollars)
int: cost_X = 1000;                   % dollars per unit of X
int: cost_Y = 500;                    % dollars per unit of Y
int: score_X = 5;                     % score coefficient for X
int: score_Y = 3;                     % score coefficient for Y

% Variables
var 0..(budget div cost_X): x;         % units of X (whole thousands)
var 0..(budget div cost_Y): y;         % units of Y (whole thousands)
var 0..budget: total_cost;            % total dollars invested

% Constraints
constraint total_cost = cost_X * x + cost_Y * y;
constraint total_cost <= budget;

constraint score_X * cost_X * x + score_Y * cost_Y * y >= min_score;

% Objective
solve minimize total_cost;