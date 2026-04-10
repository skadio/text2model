% Parameters
% Risk per dollar invested in each asset (given directly in the description)
int: risk_bond1  = 2;
int: risk_bond2  = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

% Category investment limits
int: max_bonds  = 10000;  % Bond1 + Bond2
int: max_stocks = 5000;   % Stock1 + Stock2

% Diversification / balance requirements
int: bond1_minus_stock1_min = 2000;  % Bond1 >= Stock1 + 2000
int: stock2_minus_bond2_min = 1000;  % Stock2 >= Bond2 + 1000


% Variables
% Investment amounts in dollars (non-negative; bounded by their category maxima)
var 0..max_bonds:  invest_bond1;   % dollars invested in Bond1
var 0..max_bonds:  invest_bond2;   % dollars invested in Bond2
var 0..max_stocks: invest_stock1;  % dollars invested in Stock1
var 0..max_stocks: invest_stock2;  % dollars invested in Stock2

% Total risk score (safe upper bound from max possible contributions)
var 0..(risk_bond1*max_bonds + risk_bond2*max_bonds + risk_stock1*max_stocks + risk_stock2*max_stocks): total_risk;


% Constraints
% --- Category investment limit constraints ---
constraint invest_bond1 + invest_bond2 <= max_bonds;
constraint invest_stock1 + invest_stock2 <= max_stocks;

% --- Diversification / balance constraints ---
constraint invest_bond1 >= invest_stock1 + bond1_minus_stock1_min;
constraint invest_stock2 >= invest_bond2 + stock2_minus_bond2_min;

% --- Total risk definition constraint ---
constraint total_risk =
    risk_bond1  * invest_bond1 +
    risk_bond2  * invest_bond2 +
    risk_stock1 * invest_stock1 +
    risk_stock2 * invest_stock2;


% Objective
solve minimize total_risk;