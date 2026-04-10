% Parameters
int: demand = 1000;

int: cost_coal = 50;
int: cost_gas = 60;
int: cost_solar = 70;
int: cost_nuclear = 80;

int: coal_min = 0;
int: coal_max = 600;
int: coal_reg_max = 500;

int: gas_min = 0;
int: gas_max = 400;

int: solar_min = 300;

int: nuclear_min = 100;

int: solar_ge_nuclear_plus = 200;
int: gas_solar_diff_max = 150;

% Variables
var coal_min..coal_max: coal;
var gas_min..gas_max: gas;
var solar_min..demand: solar;
var nuclear_min..demand: nuclear;

var 0..(cost_coal*coal_max + cost_gas*gas_max + cost_solar*demand + cost_nuclear*demand): total_cost;

% Constraints
constraint coal <= coal_reg_max;

constraint coal + gas + solar + nuclear >= demand;

constraint solar >= nuclear + solar_ge_nuclear_plus;

constraint abs(gas - solar) <= gas_solar_diff_max;

constraint total_cost = cost_coal*coal + cost_gas*gas + cost_solar*solar + cost_nuclear*nuclear;

% Objective
solve minimize total_cost;