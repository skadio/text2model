% Parameters
int: risk_bond1 = 2;
int: risk_bond2 = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

int: max_bonds = 10000;
int: max_stocks = 5000;

int: bond1_minus_stock1_min = 2000;
int: stock2_minus_bond2_min = 1000;

% Individual bounds (not specified explicitly in the statement beyond non-negativity)
int: min_inv = 0;
int: max_inv = 10000; % safe upper bound consistent with bond cap; stocks further capped by max_stocks

% Variables
var min_inv..max_inv: Bond1;
var min_inv..max_inv: Bond2;
var min_inv..max_inv: Stock1;
var min_inv..max_inv: Stock2;

var 0..(risk_bond1*max_bonds + risk_bond2*max_bonds + risk_stock1*max_stocks + risk_stock2*max_stocks): TotalRisk;

% Constraints
constraint Bond1 + Bond2 <= max_bonds;
constraint Stock1 + Stock2 <= max_stocks;

constraint Bond1 >= Stock1 + bond1_minus_stock1_min;
constraint Stock2 >= Bond2 + stock2_minus_bond2_min;

constraint TotalRisk = risk_bond1*Bond1 + risk_bond2*Bond2 + risk_stock1*Stock1 + risk_stock2*Stock2;

% Objective
solve minimize TotalRisk;