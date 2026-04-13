% Parameters
% Budget, impact coefficients, required minimum impact, and unit costs
int: budget = 5000;                 % Maximum total investment allowed
int: impact_per_x = 10;             % Environmental impact per unit of X
int: impact_per_y = 30;             % Environmental impact per unit of Y
int: min_total_impact = 20000;      % Minimum required combined environmental impact
int: cost_per_x = 50;               % Cost per unit of investment in X
int: cost_per_y = 60;               % Cost per unit of investment in Y

% Variables
% Integer investment decisions and total cost
var 0..budget: invest_x;            % Units invested in project X
var 0..budget: invest_y;            % Units invested in project Y
var 0..(cost_per_x*budget + cost_per_y*budget): total_cost;  % Total cost (bounded)

% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint
  invest_x + invest_y <= budget;

% Environmental impact constraint: required minimum combined impact
constraint
  impact_per_x * invest_x + impact_per_y * invest_y >= min_total_impact;

% Cost definition: total cost induced by investments in X and Y
constraint
  total_cost = cost_per_x * invest_x + cost_per_y * invest_y;

% Objective
solve minimize total_cost;

% Output
output [
  "invest_x=", show(invest_x), "\n",
  "invest_y=", show(invest_y), "\n",
  "total_cost=", show(total_cost), "\n"
];