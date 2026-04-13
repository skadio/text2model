% Parameters
int: c_stocks = 5;          % cost per $1000
int: c_bonds = 6;
int: c_mutual = 7;
int: c_gold = 8;

% Amounts are in dollars and must be whole numbers
int: stocks_min = 1000;
int: stocks_max = 5000;
int: bonds_min  = 500;
int: bonds_max  = 3000;
int: mutual_min = 2000;
int: gold_min   = 1500;

int: max_diff_stocks_bonds = 5000;  % dollars
int: mutual_minus_gold_min = 3000;  % dollars
int: total_max = 10000;             % dollars

int: stocks_min_extra = 2000;       % dollars
int: bonds_max_extra  = 4000;       % dollars (redundant given bonds_max=3000)

% Variables
var stocks_min..stocks_max: stocks;
var bonds_min..bonds_max: bonds;
var mutual_min..total_max: mutual;
var gold_min..total_max: gold;

var 0..(c_stocks*stocks_max + c_bonds*bonds_max + c_mutual*total_max + c_gold*total_max): total_cost;

% Constraints
constraint abs(stocks - bonds) <= max_diff_stocks_bonds;
constraint mutual >= gold + mutual_minus_gold_min;
constraint stocks + bonds + mutual + gold <= total_max;
constraint stocks >= stocks_min_extra;
constraint bonds <= bonds_max_extra;

% Define objective cost (costs are per $1000; amounts are dollars)
constraint total_cost = c_stocks * (stocks div 1000)
                      + c_bonds  * (bonds  div 1000)
                      + c_mutual * (mutual div 1000)
                      + c_gold   * (gold   div 1000);

% Objective
solve minimize total_cost;