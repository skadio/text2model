% Parameters
int: value_req = 50000;
int: risk_cap = 100000;

int: a1_bonds = 2;
int: a1_stocks = 3;
int: a2_bonds = 3;
int: a2_stocks = 2;

int: cost_bond = 7;
int: cost_stock = 5;

% Variables
var 0..risk_cap: bonds;
var 0..risk_cap: stocks;
var int: total_cost;

% Constraints
constraint a1_bonds * bonds + a1_stocks * stocks >= value_req;
constraint a2_bonds * bonds + a2_stocks * stocks <= risk_cap;

constraint total_cost = cost_bond * bonds + cost_stock * stocks;

% Objective
solve minimize total_cost;