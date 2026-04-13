% Parameters
% Total available land (acres)
int: total_acres = 120;

% Profit per acre for each fruit type ($/acre)
int: profit_apples  = 2000;
int: profit_pears   = 1800;
int: profit_oranges = 2200;
int: profit_lemons  = 3000;


% Variables
% Acres allocated to each fruit (bounded by total land)
var 0..total_acres: acres_apples;
var 0..total_acres: acres_pears;
var 0..total_acres: acres_oranges;
var 0..total_acres: acres_lemons;

% Indicator whether a fruit type is grown (1) or not (0)
var 0..1: grow_apples;
var 0..1: grow_pears;
var 0..1: grow_oranges;
var 0..1: grow_lemons;

% Total profit (bounded using max profit per acre * total acres)
var 0..(max([profit_apples, profit_pears, profit_oranges, profit_lemons]) * total_acres): total_profit;


% Constraints
%----------------------------
% Land availability constraint
%----------------------------
constraint
  acres_apples + acres_pears + acres_oranges + acres_lemons <= total_acres;

%---------------------------------------------------------
% Crop ratio/relationship constraints from the description
%---------------------------------------------------------
% Apples at least twice pears
constraint
  acres_apples >= 2 * acres_pears;

% Apples at least three times lemons
constraint
  acres_apples >= 3 * acres_lemons;

% Oranges must be twice lemons
constraint
  acres_oranges = 2 * acres_lemons;

%---------------------------------------------------------
% Link "grow" indicators to whether acres are allocated
%---------------------------------------------------------
% If a fruit is not grown (grow_* = 0) then its acres must be 0;
% if it is grown (grow_* = 1) it may take any value up to total_acres.
constraint
  acres_apples  <= total_acres * grow_apples /\
  acres_pears   <= total_acres * grow_pears /\
  acres_oranges <= total_acres * grow_oranges /\
  acres_lemons  <= total_acres * grow_lemons;

% Ensure logical equivalence: if acres > 0 then grow_* must be 1
% (using >= grow_* is valid here because acres_* are nonnegative integers)
constraint
  acres_apples  >= grow_apples /\
  acres_pears   >= grow_pears /\
  acres_oranges >= grow_oranges /\
  acres_lemons  >= grow_lemons;

%------------------------------------------
% At most two types of fruit are cultivated
%------------------------------------------
constraint
  grow_apples + grow_pears + grow_oranges + grow_lemons <= 2;

%-------------------------
% Total profit definition
%-------------------------
constraint
  total_profit =
    profit_apples  * acres_apples +
    profit_pears   * acres_pears +
    profit_oranges * acres_oranges +
    profit_lemons  * acres_lemons;


% Objective
solve maximize total_profit;