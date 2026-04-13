% Parameters
int: demand = 1000;

int: cost_coal = 50;
int: cost_gas = 60;
int: cost_solar = 70;
int: cost_nuclear = 80;

int: coal_min = 0;
int: coal_max_oper = 600;
int: coal_max_reg = 500;

int: gas_min = 0;
int: gas_max = 400;

int: solar_min = 300;
int: solar_max = 1000000;

int: nuclear_min = 100;
int: nuclear_max = 1000000;

int: solar_minus_nuclear_min = 200;
int: gas_solar_diff_max = 150;

% Variables
var coal_min..coal_max_oper: coal;
var gas_min..gas_max: gas;
var solar_min..solar_max: solar;
var nuclear_min..nuclear_max: nuclear;

var int: total_cost;

% Constraints
constraint coal <= coal_max_reg;

constraint coal + gas + solar + nuclear >= demand;

constraint solar - nuclear >= solar_minus_nuclear_min;

constraint abs(gas - solar) <= gas_solar_diff_max;

constraint total_cost = cost_coal * coal
                      + cost_gas * gas
                      + cost_solar * solar
                      + cost_nuclear * nuclear;

% Objective
solve minimize total_cost;