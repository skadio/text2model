% Parameters
int: cost_coal = 4;
int: cost_gas = 3;
int: cost_nuclear = 2;

int: demand = 5000;

int: cap_coal = 3000;
int: cap_gas = 2000;
int: cap_nuclear = 1500;

% Variables
var 0..cap_coal: coal;
var 0..cap_gas: gas;
var 0..cap_nuclear: nuclear;

var 0..(cost_coal*cap_coal + cost_gas*cap_gas + cost_nuclear*cap_nuclear): total_cost;

% Constraints
constraint coal + gas + nuclear >= demand;

constraint total_cost = cost_coal*coal + cost_gas*gas + cost_nuclear*nuclear;

% Objective
solve minimize total_cost;