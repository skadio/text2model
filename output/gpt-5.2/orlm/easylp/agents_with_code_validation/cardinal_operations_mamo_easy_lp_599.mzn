% Parameters
% Costs per $1000 invested (given), used as linear weights
int: cost_stocks      = 5;
int: cost_bonds       = 6;
int: cost_mutualfunds = 7;
int: cost_gold        = 8;

% Global investment limit ($)
int: total_invest_max = 10000;

% Risk/relationship constraints ($)
int: diff_stocks_bonds_max = 5000;  % |stocks - bonds| <= 5000
int: mf_minus_gold_min     = 3000;  % mutual funds >= gold + 3000

% Additional specific limits from description ($)
int: stocks_min_extra = 2000; % at least $2000 in stocks
int: bonds_max_extra  = 4000; % at most  $4000 in bonds

% Per-vehicle bounds ($)
int: stocks_min = 1000;
int: stocks_max = 5000;

int: bonds_min  = 500;
int: bonds_max  = 3000;

int: mutualfunds_min = 2000;  % no upper bound specified
int: gold_min        = 1500;  % no upper bound specified

% Derived upper bound (since total investment <= 10000, each allocation <= 10000)
int: invest_upper = total_invest_max;

% Variables
% Investment amounts in whole dollars
var stocks_min..stocks_max: stocks;                 % $ invested in stocks
var bonds_min..bonds_max: bonds;                    % $ invested in bonds
var mutualfunds_min..invest_upper: mutualfunds;     % $ invested in mutual funds
var gold_min..invest_upper: gold;                   % $ invested in gold

% Cost variables
% total_cost_weighted is in (cost-units * dollars) to avoid fractions
int: max_cost = max([cost_stocks,cost_bonds,cost_mutualfunds,cost_gold]);
var 0..(max_cost * invest_upper * 4): total_cost_weighted;
var 0..(max_cost * invest_upper * 4): total_cost_rounded_k; % rounded to nearest 1000

% Constraints
% --- Additional cross-parameter bounds (from description) ---
constraint
  stocks >= stocks_min_extra /\
  bonds  <= bonds_max_extra;

% --- Risk / relationship constraints ---
constraint abs(stocks - bonds) <= diff_stocks_bonds_max;
constraint mutualfunds >= gold + mf_minus_gold_min;

% --- Total investment budget constraint ---
constraint stocks + bonds + mutualfunds + gold <= total_invest_max;

% --- Cost aggregation and rounding constraints ---
constraint
  total_cost_weighted =
      cost_stocks      * stocks
    + cost_bonds       * bonds
    + cost_mutualfunds * mutualfunds
    + cost_gold        * gold;

% Round weighted cost / 1000 to nearest integer: floor((x + 500)/1000) for x >= 0
constraint total_cost_rounded_k = (total_cost_weighted + 500) div 1000;

% Objective
solve minimize total_cost_rounded_k;