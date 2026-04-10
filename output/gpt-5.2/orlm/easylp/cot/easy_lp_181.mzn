% Parameters (with values embedded)
int: demand = 500;
int: limit1 = 200;
int: limit2 = 150;

int: cost_coal = 20;
int: cost_gas = 30;
int: cost_nuclear = 40;

% Scaled constraints to avoid fractions:
% (1/2)coal - (1/5)gas + nuclear <= 200  ==>  5*coal - 2*gas + 10*nuclear <= 2000
% coal - gas + 0.4*nuclear >= 150       ==>  5*coal - 5*gas + 2*nuclear >= 750
int: scale1 = 2000;
int: scale2 = 750;

% Variables
var 0..100000: coal;
var 0..100000: gas;
var 0..100000: nuclear;

var 0..1000000000: total_cost;

% Constraints
constraint coal + gas + nuclear >= demand;

constraint 5*coal - 2*gas + 10*nuclear <= scale1;
constraint 5*coal - 5*gas + 2*nuclear >= scale2;

constraint total_cost = cost_coal*coal + cost_gas*gas + cost_nuclear*nuclear;

% Objective
solve minimize total_cost;