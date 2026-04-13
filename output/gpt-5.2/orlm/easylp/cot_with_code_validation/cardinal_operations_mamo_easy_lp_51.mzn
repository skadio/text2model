% Parameters
int: max_items = 200;
int: min_sales = 150;
int: sales_x = 3;
int: sales_y = 2;
int: cost_x = 5;
int: cost_y = 10;

% Variables
var 0..max_items: x;
var 0..max_items: y;
var 0..(max_items * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= max_items;
constraint sales_x * x + sales_y * y >= min_sales;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;