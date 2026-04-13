% Parameters
% Embedded directly (no .dzn input expected)
int: max_total_investment = 20;     % Budget limit on invest_x + invest_y
int: min_impact = 10;              % Minimum required impact: 2*invest_x + invest_y >= 10
int: impact_x = 2;                 % Impact coefficient for Project X
int: impact_y = 1;                 % Impact coefficient for Project Y
int: cost_x = 4;                   % Cost per unit investment in Project X
int: cost_y = 5;                   % Cost per unit investment in Project Y

% Variables
var 0..max_total_investment: invest_x;  % Integer investment in Project X
var 0..max_total_investment: invest_y;  % Integer investment in Project Y
var 0..(cost_x*max_total_investment + cost_y*max_total_investment): total_cost; % Total cost upper bound

% Constraints
% Budget limit on combined investment
constraint invest_x + invest_y <= max_total_investment;

% Minimum required environmental impact
constraint impact_x * invest_x + impact_y * invest_y >= min_impact;

% Define total cost based on per-unit costs
constraint total_cost = cost_x * invest_x + cost_y * invest_y;

% Objective
solve minimize total_cost;

output [
  "invest_x=", show(invest_x), "\n",
  "invest_y=", show(invest_y), "\n",
  "total_cost=", show(total_cost), "\n"
];