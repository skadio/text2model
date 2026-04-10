% Parameters
int: sell_table = 200;
int: sell_chair = 50;
int: sell_shelf = 150;

int: cost_table = 120;
int: cost_chair = 20;
int: cost_shelf = 90;

int: space_table = 5;
int: space_chair = 2;
int: space_shelf = 3;

int: max_space = 500;
int: min_tables = 10;
int: min_shelves = 20;
int: max_items = 200;

int: profit_table = sell_table - cost_table;
int: profit_chair = sell_chair - cost_chair;
int: profit_shelf = sell_shelf - cost_shelf;

% Variables
var 0..max_items: tables;
var 0..max_items: chairs;
var 0..max_items: shelves;

var 0..(max_items * profit_table + max_items * profit_chair + max_items * profit_shelf): total_profit;

% Constraints
constraint tables >= min_tables;
constraint shelves >= min_shelves;

constraint tables + chairs + shelves <= max_items;

constraint space_table * tables + space_chair * chairs + space_shelf * shelves <= max_space;

constraint total_profit = profit_table * tables + profit_chair * chairs + profit_shelf * shelves;

% Objective
solve maximize total_profit;