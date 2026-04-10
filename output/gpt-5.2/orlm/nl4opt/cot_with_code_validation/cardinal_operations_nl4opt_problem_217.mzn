% Parameters
int: gas_avail = 1000;
int: water_avail = 800;

int: gas_A = 5;
int: water_A = 6;
int: prod_A = 10;

int: gas_B = 7;
int: water_B = 3;
int: prod_B = 8;

% Variables
var 0..gas_avail div gas_A: xA;          % number of reaction A runs
var 0..gas_avail div gas_B: xB;          % number of reaction B runs
var 0..(prod_A * (gas_avail div gas_A) + prod_B * (gas_avail div gas_B)): total_prod;

% Constraints
constraint gas_A * xA + gas_B * xB <= gas_avail;
constraint water_A * xA + water_B * xB <= water_avail;

constraint total_prod = prod_A * xA + prod_B * xB;

% Objective
solve maximize total_prod;