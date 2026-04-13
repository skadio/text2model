% Parameters
int: max_total_investment = 20;   % Budget limit on combined investment units (X + Y)
int: min_impact = 10;            % Minimum required environmental impact score

int: impact_per_x = 2;           % Impact contribution per unit invested in Project X
int: impact_per_y = 1;           % Impact contribution per unit invested in Project Y

int: cost_per_x = 4;             % Cost per unit invested in Project X
int: cost_per_y = 5;             % Cost per unit invested in Project Y

% Variables
var 0..max_total_investment: invest_x;  % Whole-number units invested in Project X
var 0..max_total_investment: invest_y;  % Whole-number units invested in Project Y

% Total cost to minimize (safe upper bound when both at max)
var 0..(cost_per_x*max_total_investment + cost_per_y*max_total_investment): total_cost;

% Constraints
% Budget limit: total investment units across both projects cannot exceed maximum
constraint invest_x + invest_y <= max_total_investment;

% Minimum environmental impact requirement
constraint impact_per_x * invest_x + impact_per_y * invest_y >= min_impact;

% Total cost definition
constraint total_cost = cost_per_x * invest_x + cost_per_y * invest_y;

% Objective
solve minimize total_cost;

output [
  "invest_x=", show(invest_x), "\n",
  "invest_y=", show(invest_y), "\n",
  "total_cost=", show(total_cost), "\n"
];