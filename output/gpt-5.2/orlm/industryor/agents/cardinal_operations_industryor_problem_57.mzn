% Parameters
int: total_acres = 120;                          % Total available land (acres)

int: profit_apples  = 2000;                      % Profit per acre for apples
int: profit_pears   = 1800;                      % Profit per acre for pears
int: profit_oranges = 2200;                      % Profit per acre for oranges
int: profit_lemons  = 3000;                      % Profit per acre for lemons


% Variables
var 0..total_acres: acres_apples;                % Acres allocated to apples
var 0..total_acres: acres_pears;                 % Acres allocated to pears
var 0..total_acres: acres_oranges;               % Acres allocated to oranges
var 0..total_acres: acres_lemons;                % Acres allocated to lemons

var bool: grow_apples;                           % true if apples are grown
var bool: grow_pears;                            % true if pears are grown
var bool: grow_oranges;                          % true if oranges are grown
var bool: grow_lemons;                           % true if lemons are grown

var int: total_profit;                           % Total profit (objective value)


% Constraints

% Land availability: total planted acres cannot exceed available land
constraint
  acres_apples + acres_pears + acres_oranges + acres_lemons <= total_acres;

% Link "grow" booleans to whether a fruit is planted (reified by acreage > 0)
constraint (acres_apples  > 0) <-> grow_apples;
constraint (acres_pears   > 0) <-> grow_pears;
constraint (acres_oranges > 0) <-> grow_oranges;
constraint (acres_lemons  > 0) <-> grow_lemons;

% Agronomic/business ratio constraints between crop acreages
constraint acres_apples >= 2 * acres_pears;      % Apples at least twice pears
constraint acres_apples >= 3 * acres_lemons;     % Apples at least three times lemons
constraint acres_oranges = 2 * acres_lemons;     % Oranges exactly twice lemons

% At most two types of fruit are grown
constraint
  grow_apples + grow_pears + grow_oranges + grow_lemons <= 2;

% Define total profit from acre allocations
constraint
  total_profit =
    profit_apples  * acres_apples +
    profit_pears   * acres_pears +
    profit_oranges * acres_oranges +
    profit_lemons  * acres_lemons;


% Objective
solve maximize total_profit;