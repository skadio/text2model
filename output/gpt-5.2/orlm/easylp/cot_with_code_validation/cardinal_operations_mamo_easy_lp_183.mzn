% Parameters
int: coal_cost = 4;
int: gas_cost = 3;
int: nuclear_cost = 2;

int: demand_min = 5000;

int: coal_cap = 3000;
int: gas_cap = 2000;
int: nuclear_cap = 1500;

% Variables
var 0..coal_cap: coal;
var 0..gas_cap: gas;
var 0..nuclear_cap: nuclear;

var 0..(coal_cost*coal_cap + gas_cost*gas_cap + nuclear_cost*nuclear_cap): total_cost;

% Constraints
constraint coal + gas + nuclear >= demand_min;

constraint total_cost = coal_cost*coal + gas_cost*gas + nuclear_cost*nuclear;

% Objective
solve minimize total_cost;