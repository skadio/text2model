% Parameters
% Risk units per dollar invested (or per unit of investment) for each asset
int: risk_bond1  = 2;
int: risk_bond2  = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

% Maximum total investment allowed by category
int: max_total_bonds  = 10000;  % Bond1 + Bond2
int: max_total_stocks = 5000;   % Stock1 + Stock2

% Diversification / balance requirements (minimum differences)
int: min_bond1_over_stock1 = 2000; % Bond1 >= Stock1 + 2000
int: min_stock2_over_bond2 = 1000; % Stock2 >= Bond2 + 1000

% NOTE: The description mentions "individual bounds on investments for each asset type"
% but does not provide numeric values. Therefore, only non-negativity bounds are used.

% Variables
var 0..max_total_bonds:  invest_bond1;   % amount invested in Bond1
var 0..max_total_bonds:  invest_bond2;   % amount invested in Bond2
var 0..max_total_stocks: invest_stock1;  % amount invested in Stock1
var 0..max_total_stocks: invest_stock2;  % amount invested in Stock2

% Total risk score (objective expression)
var int: total_risk =
  risk_bond1  * invest_bond1 +
  risk_bond2  * invest_bond2 +
  risk_stock1 * invest_stock1 +
  risk_stock2 * invest_stock2;

% Constraints
% --- Category investment caps ---
constraint invest_bond1 + invest_bond2 <= max_total_bonds;
constraint invest_stock1 + invest_stock2 <= max_total_stocks;

% --- Diversification / balance requirements ---
% Bond1 must be at least $2000 more than Stock1
constraint invest_bond1 >= invest_stock1 + min_bond1_over_stock1;

% Stock2 must be at least $1000 more than Bond2
constraint invest_stock2 >= invest_bond2 + min_stock2_over_bond2;

% Objective
solve minimize total_risk;