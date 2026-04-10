% Furniture production planning (maximize profit)
include "globals.mzn";

% Data (embedded)
int: sell_table = 200;
int: sell_chair = 50;
int: sell_bookshelf = 150;

int: cost_table = 120;
int: cost_chair = 20;
int: cost_bookshelf = 90;

int: space_table = 5;
int: space_chair = 2;
int: space_bookshelf = 3;

int: max_space = 500;
int: max_items = 200;

int: min_tables = 10;
int: min_bookshelves = 20;

% Profit per item
int: profit_table = sell_table - cost_table;           % 80
int: profit_chair = sell_chair - cost_chair;           % 30
int: profit_bookshelf = sell_bookshelf - cost_bookshelf; % 60

% Decision variables
var 0..max_items: tables;
var 0..max_items: chairs;
var 0..max_items: bookshelves;

% Constraints
constraint tables >= min_tables;
constraint bookshelves >= min_bookshelves;

constraint tables + chairs + bookshelves <= max_items;

constraint space_table * tables + space_chair * chairs + space_bookshelf * bookshelves <= max_space;

% Objective
var int: total_profit =
    profit_table * tables + profit_chair * chairs + profit_bookshelf * bookshelves;

solve maximize total_profit;

output [
  "tables=", show(tables), "\n",
  "chairs=", show(chairs), "\n",
  "bookshelves=", show(bookshelves), "\n",
  "total_items=", show(tables + chairs + bookshelves), "\n",
  "used_space=", show(space_table * tables + space_chair * chairs + space_bookshelf * bookshelves), "\n",
  "total_profit=", show(total_profit), "\n"
];