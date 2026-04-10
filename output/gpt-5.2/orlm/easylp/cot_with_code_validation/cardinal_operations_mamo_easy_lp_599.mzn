% Parameters
int: cost_stocks = 5;      % in units of $1000
int: cost_bonds = 6;       % in units of $1000
int: cost_mutual = 7;      % in units of $1000
int: cost_gold = 8;        % in units of $1000

% All amounts are in whole dollars
int: stocks_lb = 1000;
int: stocks_ub = 5000;

int: bonds_lb = 500;
int: bonds_ub = 3000;

int: mutual_lb = 2000;
int: gold_lb   = 1500;

int: diff_stocks_bonds_ub = 5000;
int: mutual_minus_gold_lb = 3000;

int: total_invest_ub = 10000;

int: min_stocks_extra = 2000;
int: max_bonds_extra  = 4000;

% Variables
var stocks_lb..stocks_ub: stocks;
var bonds_lb..bonds_ub: bonds;
var mutual_lb..total_invest_ub: mutual;
var gold_lb..total_invest_ub: gold;

var 0..(cost_stocks*stocks_ub + cost_bonds*bonds_ub + cost_mutual*total_invest_ub + cost_gold*total_invest_ub): total_cost;

% Constraints
constraint abs(stocks - bonds) <= diff_stocks_bonds_ub;

constraint mutual >= gold + mutual_minus_gold_lb;

constraint stocks + bonds + mutual + gold <= total_invest_ub;

constraint stocks >= min_stocks_extra;

constraint bonds <= max_bonds_extra;

constraint total_cost =
  cost_stocks * stocks +
  cost_bonds  * bonds +
  cost_mutual * mutual +
  cost_gold   * gold;

% Objective
solve minimize total_cost;