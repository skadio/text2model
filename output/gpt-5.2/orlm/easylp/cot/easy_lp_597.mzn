% Parameters (with values embedded)
int: max_bonds = 10000;
int: max_stocks = 5000;

int: risk_bond1 = 2;
int: risk_bond2 = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

int: min_bond1_minus_stock1 = 2000;
int: min_stock2_minus_bond2 = 1000;

% NOTE: The description mentions "individual bounds on investments for each asset type"
% but does not provide numeric values. We therefore use non-negativity as the only explicit bound.
% Variables
var 0..max_bonds: Bond1;
var 0..max_bonds: Bond2;
var 0..max_stocks: Stock1;
var 0..max_stocks: Stock2;

% Constraints
constraint Bond1 + Bond2 <= max_bonds;
constraint Stock1 + Stock2 <= max_stocks;

constraint Bond1 >= Stock1 + min_bond1_minus_stock1;
constraint Stock2 >= Bond2 + min_stock2_minus_bond2;

% Objective
var 0..(risk_bond1*max_bonds + risk_bond2*max_bonds + risk_stock1*max_stocks + risk_stock2*max_stocks): total_risk;
constraint total_risk = risk_bond1*Bond1 + risk_bond2*Bond2 + risk_stock1*Stock1 + risk_stock2*Stock2;

solve minimize total_risk;