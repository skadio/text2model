% Parameters
% Costs (in units of $1000)
int: cost_stocks = 5;
int: cost_bonds  = 6;
int: cost_mutual = 7;
int: cost_gold   = 8;

% Global limits/requirements (in dollars)
int: max_diff_stocks_bonds = 5000;   % |stocks - bonds| <= 5000
int: min_mutual_minus_gold = 3000;   % mutual - gold >= 3000
int: max_total_investment  = 10000;  % total investment cap
int: min_stocks_alloc      = 2000;   % stocks >= 2000
int: max_bonds_alloc       = 4000;   % bonds <= 4000

% Per-asset bounds (in dollars)
int: stocks_lb = 1000;
int: stocks_ub = 5000;

int: bonds_lb  = 500;
int: bonds_ub  = 3000;

int: mutual_lb = 2000;
int: mutual_ub = max_total_investment; % implied upper bound

int: gold_lb   = 1500;
int: gold_ub   = max_total_investment; % implied upper bound


% Variables
% Investment amounts in dollars (whole-number dollars)
var stocks_lb..stocks_ub: invest_stocks;
var bonds_lb..bonds_ub:   invest_bonds;
var mutual_lb..mutual_ub: invest_mutual;
var gold_lb..gold_ub:     invest_gold;

% Total cost in units of $1000 (integer variable)
var 0..(cost_stocks*stocks_ub + cost_bonds*bonds_ub + cost_mutual*mutual_ub + cost_gold*gold_ub): total_cost_k;

% Rounded total cost to nearest $1000 (integer number of thousands of dollars)
var 0..(cost_stocks*stocks_ub + cost_bonds*bonds_ub + cost_mutual*mutual_ub + cost_gold*gold_ub): rounded_cost_k;


% Constraints
% --- Per-asset bounds & explicit min/max requirements ---
constraint invest_stocks >= min_stocks_alloc;  % stronger than stocks_lb
constraint invest_bonds  <= max_bonds_alloc;   % redundant given bonds_ub=3000, kept for clarity

% --- Risk/relative-allocation constraints ---
constraint abs(invest_stocks - invest_bonds) <= max_diff_stocks_bonds;
constraint invest_mutual - invest_gold >= min_mutual_minus_gold;

% --- Total investment limit ---
constraint invest_stocks + invest_bonds + invest_mutual + invest_gold <= max_total_investment;

% --- Total cost computation (costs are per $1000 invested) ---
% Avoid fractional division by scaling:
% 1000 * total_cost_k = sum(cost_i * invest_i)
constraint
  1000 * total_cost_k =
      cost_stocks * invest_stocks
    + cost_bonds  * invest_bonds
    + cost_mutual * invest_mutual
    + cost_gold   * invest_gold;

% --- Rounding total cost to nearest $1000 ---
% total_cost_k is already integer, so rounding is identity.
constraint rounded_cost_k = total_cost_k;


% Objective
solve minimize rounded_cost_k;