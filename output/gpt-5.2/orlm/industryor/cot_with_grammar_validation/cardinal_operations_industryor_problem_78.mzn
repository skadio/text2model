% Parameters
int: price_table = 200;
int: price_chair = 50;
int: price_bookshelf = 150;

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

int: profit_table = price_table - cost_table;
int: profit_chair = price_chair - cost_chair;
int: profit_bookshelf = price_bookshelf - cost_bookshelf;

% Variables
var 0..max_items: tables;
var 0..max_items: chairs;
var 0..max_items: bookshelves;

var int: total_profit;

% Constraints
constraint tables >= min_tables;
constraint bookshelves >= min_bookshelves;

constraint space_table * tables + space_chair * chairs + space_bookshelf * bookshelves <= max_space;

constraint tables + chairs + bookshelves <= max_items;

constraint total_profit = profit_table * tables + profit_chair * chairs + profit_bookshelf * bookshelves;

% Objective
solve maximize total_profit;