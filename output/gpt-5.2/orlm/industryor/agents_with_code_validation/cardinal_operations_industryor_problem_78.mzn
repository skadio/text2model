% Parameters
int: sell_price_table = 200;        % Selling price per table
int: sell_price_chair = 50;         % Selling price per chair
int: sell_price_bookshelf = 150;    % Selling price per bookshelf

int: cost_table = 120;              % Manufacturing cost per table
int: cost_chair = 20;               % Manufacturing cost per chair
int: cost_bookshelf = 90;           % Manufacturing cost per bookshelf

int: space_table = 5;               % Warehouse space per table (sqm)
int: space_chair = 2;               % Warehouse space per chair (sqm)
int: space_bookshelf = 3;           % Warehouse space per bookshelf (sqm)

int: max_warehouse_space = 500;     % Maximum available warehouse space (sqm)
int: min_tables = 10;               % Minimum number of tables to produce
int: min_bookshelves = 20;          % Minimum number of bookshelves to produce
int: max_total_items = 200;         % Maximum total number of items produced

int: profit_table = sell_price_table - cost_table;             % Profit per table
int: profit_chair = sell_price_chair - cost_chair;             % Profit per chair
int: profit_bookshelf = sell_price_bookshelf - cost_bookshelf; % Profit per bookshelf

% Variables
var 0..max_total_items: num_tables;        % Number of tables to produce
var 0..max_total_items: num_chairs;        % Number of chairs to produce
var 0..max_total_items: num_bookshelves;   % Number of bookshelves to produce
var int: total_profit;                     % Total profit (to be maximized)

% Constraints

% --- Demand minimums ---
constraint num_tables >= min_tables;                 % Produce at least the minimum required tables
constraint num_bookshelves >= min_bookshelves;       % Produce at least the minimum required bookshelves

% --- Warehouse space capacity ---
constraint
  space_table * num_tables +
  space_chair * num_chairs +
  space_bookshelf * num_bookshelves
  <= max_warehouse_space;                            % Total warehouse space used cannot exceed capacity

% --- Total production limit ---
constraint
  num_tables + num_chairs + num_bookshelves
  <= max_total_items;                                % Total items produced cannot exceed limit

% --- Total profit definition ---
constraint
  total_profit =
    profit_table * num_tables +
    profit_chair * num_chairs +
    profit_bookshelf * num_bookshelves;              % Total profit computed from per-item profits

% Objective
solve maximize total_profit;