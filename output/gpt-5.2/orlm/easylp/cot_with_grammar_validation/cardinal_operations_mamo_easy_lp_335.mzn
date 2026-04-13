% Parameters
int: demand = 1000;

int: coal_cost = 50;
int: gas_cost = 60;
int: solar_cost = 70;
int: nuclear_cost = 80;

int: coal_min = 0;
int: coal_max_oper = 600;
int: coal_max_reg = 500;

int: gas_min = 0;
int: gas_max = 400;

int: solar_min = 300;
int: solar_max = demand + coal_max_reg + gas_max + solar_min + 1000; % safe upper bound

int: nuclear_min = 100;
int: nuclear_max = demand + coal_max_reg + gas_max + solar_min + 1000; % safe upper bound

int: solar_minus_nuclear_min = 200;
int: gas_solar_diff_max = 150;

% Variables
var coal_min..coal_max_oper: coal;
var gas_min..gas_max: gas;
var solar_min..solar_max: solar;
var nuclear_min..nuclear_max: nuclear;

var 0..(coal_cost*coal_max_reg + gas_cost*gas_max + solar_cost*solar_max + nuclear_cost*nuclear_max): total_cost;

% Constraints
constraint coal <= coal_max_reg;

constraint coal + gas + solar + nuclear >= demand;

constraint solar - nuclear >= solar_minus_nuclear_min;

constraint abs(gas - solar) <= gas_solar_diff_max;

constraint total_cost = coal_cost*coal + gas_cost*gas + solar_cost*solar + nuclear_cost*nuclear;

% Objective
solve minimize total_cost;