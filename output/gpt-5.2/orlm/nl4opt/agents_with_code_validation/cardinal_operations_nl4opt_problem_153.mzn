% Parameters
% Profit per cookie type
float: profit_strawberry = 5.5;
float: profit_sugar      = 12.0;

% Demand upper bounds
int: max_demand_strawberry = 100;
int: max_demand_sugar      = 80;

% Total daily production capacity (either type combined)
int: max_total_cookies = 100;

% Variables
% Number of cookies to produce (nonnegative and bounded by demand/capacity)
var 0..max_demand_strawberry: x_strawberry;
var 0..max_demand_sugar:      x_sugar;

% Constraints
% Total production capacity (combined cookies per day)
constraint
  x_strawberry + x_sugar <= max_total_cookies;

% Objective
solve maximize profit_strawberry * x_strawberry + profit_sugar * x_sugar;