% Parameters
int: sell_price_table = 200;
int: sell_price_chair = 50;
int: sell_price_bookshelf = 150;

int: cost_table = 120;
int: cost_chair = 20;
int: cost_bookshelf = 90;

int: space_table = 5;        % square meters per table
int: space_chair = 2;        % square meters per chair
int: space_bookshelf = 3;    % square meters per bookshelf

int: max_space = 500;        % maximum total warehouse space (sqm)
int: min_tables = 10;        % minimum tables to produce
int: min_bookshelves = 20;   % minimum bookshelves to produce
int: max_items = 200;        % maximum total number of items produced

% Unit profits (selling price - manufacturing cost)
int: profit_table = sell_price_table - cost_table;
int: profit_chair = sell_price_chair - cost_chair;
int: profit_bookshelf = sell_price_bookshelf - cost_bookshelf;

% Variables
var 0..max_items: num_tables;       % number of tables produced
var 0..max_items: num_chairs;       % number of chairs produced
var 0..max_items: num_bookshelves;  % number of bookshelves produced

% Constraints
% Warehouse space capacity constraint
constraint
  space_table * num_tables
+ space_chair * num_chairs
+ space_bookshelf * num_bookshelves
<= max_space;

% Minimum production requirements (market demand)
constraint num_tables >= min_tables;
constraint num_bookshelves >= min_bookshelves;

% Total production limit (overall item cap)
constraint num_tables + num_chairs + num_bookshelves <= max_items;

% Objective
solve maximize
  profit_table * num_tables
+ profit_chair * num_chairs
+ profit_bookshelf * num_bookshelves;