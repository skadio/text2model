% Parameters
float: profit_strawberry = 5.5;
float: profit_sugar = 12.0;

int: demand_max_strawberry = 100;
int: demand_max_sugar = 80;

int: capacity_total = 100;

% Variables
var 0..demand_max_strawberry: x1; % strawberry cookies
var 0..demand_max_sugar: x2;      % sugar cookies

var float: total_profit;

% Constraints
constraint x1 + x2 <= capacity_total;

constraint total_profit = profit_strawberry * int2float(x1)
                        + profit_sugar * int2float(x2);

% Objective
solve maximize total_profit;