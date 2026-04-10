% Parameters
float: profit_strawberry = 5.5;
float: profit_sugar = 12.0;

int: demand_strawberry_max = 100;
int: demand_sugar_max = 80;

int: capacity_total_max = 100;

% Variables
var 0..demand_strawberry_max: x1; % strawberry cookies
var 0..demand_sugar_max: x2;      % sugar cookies

var float: total_profit;

% Constraints
constraint x1 + x2 <= capacity_total_max;

constraint total_profit = profit_strawberry * int2float(x1) + profit_sugar * int2float(x2);

% Objective
solve maximize total_profit;