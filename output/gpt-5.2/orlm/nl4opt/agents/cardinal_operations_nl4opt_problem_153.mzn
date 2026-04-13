% Parameters
float: profit_strawberry = 5.5;     % Profit per strawberry cookie
float: profit_sugar = 12.0;         % Profit per sugar cookie

int: demand_max_strawberry = 100;   % Maximum daily demand for strawberry cookies
int: demand_max_sugar = 80;         % Maximum daily demand for sugar cookies
int: capacity_max_total = 100;      % Maximum total cookies produced per day (either type)

% Variables
var 0..demand_max_strawberry: x_strawberry; % Number of strawberry cookies to make
var 0..demand_max_sugar: x_sugar;           % Number of sugar cookies to make

% Constraints
% Demand limits (also enforced by variable domains; included explicitly for clarity)
constraint x_strawberry <= demand_max_strawberry;
constraint x_sugar <= demand_max_sugar;

% Production capacity limit: total cookies made per day cannot exceed staff capacity
constraint x_strawberry + x_sugar <= capacity_max_total;

% Objective
solve maximize profit_strawberry * int2float(x_strawberry)
             + profit_sugar * int2float(x_sugar);