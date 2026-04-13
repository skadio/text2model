% Parameters
int: cost_coal = 10;
int: cost_gas = 15;
int: cost_nuclear = 20;
int: cost_solar = 25;

int: min_coal_gas = 400;
int: max_diff_nuclear_solar = 100;
int: min_coal_minus_nuclear = 200;
int: min_gas_solar = 500;

% Variables
var 0..1000000: coal;
var 0..1000000: gas;
var 0..1000000: nuclear;
var 0..1000000: solar;

var 0..100000000: total_cost;

% Constraints
constraint coal + gas >= min_coal_gas;
constraint abs(nuclear - solar) <= max_diff_nuclear_solar;
constraint coal - nuclear >= min_coal_minus_nuclear;
constraint gas + solar >= min_gas_solar;

constraint total_cost =
  cost_coal * coal +
  cost_gas * gas +
  cost_nuclear * nuclear +
  cost_solar * solar;

% Objective
solve minimize total_cost;