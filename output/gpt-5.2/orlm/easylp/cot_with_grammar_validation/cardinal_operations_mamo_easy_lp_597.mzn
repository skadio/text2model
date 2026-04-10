% Parameters
int: risk_bond1 = 2;
int: risk_bond2 = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

int: max_bonds = 10000;
int: max_stocks = 5000;

int: diff_b1_s1 = 2000;
int: diff_s2_b2 = 1000;

% Variables
var 0..max_bonds: Bond1;
var 0..max_bonds: Bond2;
var 0..max_stocks: Stock1;
var 0..max_stocks: Stock2;

var 0..(risk_bond1*max_bonds + risk_bond2*max_bonds + risk_stock1*max_stocks + risk_stock2*max_stocks): TotalRisk;

% Constraints
constraint Bond1 + Bond2 <= max_bonds;
constraint Stock1 + Stock2 <= max_stocks;

constraint Bond1 >= Stock1 + diff_b1_s1;
constraint Stock2 >= Bond2 + diff_s2_b2;

constraint TotalRisk = risk_bond1*Bond1 + risk_bond2*Bond2 + risk_stock1*Stock1 + risk_stock2*Stock2;

% Objective
solve minimize TotalRisk;