% Parameters
% Ingredient availability (kg)
float: avail_cat_paw = 20.0;
float: avail_gold_shark = 50.0;

% Mix composition fractions
float: mix1_cat_paw_frac = 0.20;
float: mix1_gold_shark_frac = 0.80;
float: mix2_cat_paw_frac = 0.35;
float: mix2_gold_shark_frac = 0.65;

% Profit per kg ($/kg)
float: profit_mix1 = 12.0;
float: profit_mix2 = 15.0;


% Variables
% Decision variables: kg produced of each mix (nonnegative)
% Upper bounds derived from cat paw availability alone (safe, finite bounds)
var 0.0..(avail_cat_paw / mix1_cat_paw_frac): kg_mix1;
var 0.0..(avail_cat_paw / mix2_cat_paw_frac): kg_mix2;

% Total profit variable (bounded for clarity)
var 0.0..(profit_mix1 * (avail_cat_paw / mix1_cat_paw_frac)
        + profit_mix2 * (avail_cat_paw / mix2_cat_paw_frac)): total_profit;


% Constraints
% Resource constraints: do not exceed available ingredients
constraint
  mix1_cat_paw_frac * kg_mix1 + mix2_cat_paw_frac * kg_mix2 <= avail_cat_paw;          % Cat paw usage

constraint
  mix1_gold_shark_frac * kg_mix1 + mix2_gold_shark_frac * kg_mix2 <= avail_gold_shark; % Gold shark usage

% Profit accounting: define total profit from produced mixes
constraint
  total_profit = profit_mix1 * kg_mix1 + profit_mix2 * kg_mix2;


% Objective
solve maximize total_profit;