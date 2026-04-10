% Parameters
int: risk_bond1 = 2;
int: risk_bond2 = 3;
int: risk_stock1 = 4;
int: risk_stock2 = 5;

int: max_bonds_total = 10000;
int: max_stocks_total = 5000;

int: bond1_minus_stock1_min = 2000;
int: stock2_minus_bond2_min = 1000;

% No explicit individual bounds were provided; assume non-negative investments.
int: max_invest = max_bonds_total + max_stocks_total;

% Variables
var 0..max_invest: bond1;
var 0..max_invest: bond2;
var 0..max_invest: stock1;
var 0..max_invest: stock2;

var 0..(risk_bond1*max_invest + risk_bond2*max_invest + risk_stock1*max_invest + risk_stock2*max_invest): total_risk;

% Constraints
constraint bond1 + bond2 <= max_bonds_total;
constraint stock1 + stock2 <= max_stocks_total;

constraint bond1 >= stock1 + bond1_minus_stock1_min;
constraint stock2 >= bond2 + stock2_minus_bond2_min;

constraint total_risk = risk_bond1*bond1 + risk_bond2*bond2 + risk_stock1*stock1 + risk_stock2*stock2;

% Objective
solve minimize total_risk;