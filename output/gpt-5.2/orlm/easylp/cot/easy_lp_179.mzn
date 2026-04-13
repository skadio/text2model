% Parameters (with values embedded)
int: demand = 1000;
int: env_limit = 500;
int: nuclear_extra = 200;

int: cost_coal = 50;
int: cost_gas = 40;
int: cost_nuclear = 60;

% Variables
var 0..demand: coal;
var 0..demand: gas;
var 0..(3*demand): nuclear;

var 0..(cost_coal*demand + cost_gas*demand + cost_nuclear*(3*demand)): total_cost;

% Constraints
constraint coal + gas + nuclear >= demand;
constraint 3 * coal - gas <= env_limit;
constraint nuclear >= 2 * gas + nuclear_extra;

constraint total_cost = cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear;

% Objective
solve minimize total_cost;