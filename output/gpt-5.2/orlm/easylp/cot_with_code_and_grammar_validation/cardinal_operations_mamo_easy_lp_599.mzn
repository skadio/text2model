% Parameters
int: cost_stocks = 5;        % in units of $1000
int: cost_bonds = 6;         % in units of $1000
int: cost_mutual = 7;        % in units of $1000
int: cost_gold = 8;          % in units of $1000

int: max_diff_stocks_bonds = 5;     % $5000 -> 5 (in $1000 units)
int: min_mutual_minus_gold = 3;     % $3000 -> 3 (in $1000 units)
int: max_total_invest = 10;         % $10000 -> 10 (in $1000 units)

int: min_stocks_total = 2;          % $2000 -> 2 (in $1000 units)
int: max_bonds_total = 4;           % $4000 -> 4 (in $1000 units)

int: lb_stocks = 1;                 % $1000 -> 1
int: ub_stocks = 5;                 % $5000 -> 5
int: lb_bonds = 1;                  % $500 -> 0.5, but whole numbers => 1 ($1000 units)
int: ub_bonds = 3;                  % $3000 -> 3
int: lb_mutual = 2;                 % $2000 -> 2
int: lb_gold = 2;                   % $1500 -> 1.5, but whole numbers => 2 ($1000 units)

% Variables
var lb_stocks..ub_stocks: stocks;   % in $1000 units
var lb_bonds..ub_bonds: bonds;      % in $1000 units
var lb_mutual..max_total_invest: mutual_funds; % in $1000 units
var lb_gold..max_total_invest: gold;           % in $1000 units

var 0..(cost_stocks*ub_stocks + cost_bonds*ub_bonds + cost_mutual*max_total_invest + cost_gold*max_total_invest): total_cost;

% Constraints
constraint abs(stocks - bonds) <= max_diff_stocks_bonds;
constraint mutual_funds - gold >= min_mutual_minus_gold;
constraint stocks + bonds + mutual_funds + gold <= max_total_invest;

constraint stocks >= min_stocks_total;
constraint bonds <= max_bonds_total;

constraint total_cost = cost_stocks*stocks + cost_bonds*bonds + cost_mutual*mutual_funds + cost_gold*gold;

% Objective
solve minimize total_cost;