% Parameters (with values embedded)
int: max_strawberry_demand = 100;
int: max_sugar_demand = 80;
int: max_total_cookies = 100;

float: profit_strawberry = 5.5;
float: profit_sugar = 12.0;

% Variables
var 0..max_strawberry_demand: x1; % strawberry cookies
var 0..max_sugar_demand: x2;      % sugar cookies

% Constraints
constraint x1 + x2 <= max_total_cookies;

% Objective
solve maximize profit_strawberry * int2float(x1) + profit_sugar * int2float(x2);