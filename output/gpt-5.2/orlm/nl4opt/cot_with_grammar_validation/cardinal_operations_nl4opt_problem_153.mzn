% Parameters
float: profit_strawberry = 5.5;
float: profit_sugar = 12.0;

int: demand_max_strawberry = 100;
int: demand_max_sugar = 80;

int: production_max_total = 100;

% Variables
var 0..demand_max_strawberry: x1; % strawberry cookies
var 0..demand_max_sugar: x2;      % sugar cookies

% Constraints
constraint x1 + x2 <= production_max_total;

% Objective
solve maximize profit_strawberry * x1 + profit_sugar * x2;