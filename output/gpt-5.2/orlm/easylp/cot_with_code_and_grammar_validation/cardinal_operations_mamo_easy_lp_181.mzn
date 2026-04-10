% Parameters
int: demand = 500;

int: cost_coal = 20;
int: cost_gas = 30;
int: cost_nuclear = 40;

int: measure1_max = 200;   % (1/2)coal - (1/5)gas + 1*nuclear <= 200
int: measure2_min = 150;   % 1*coal - 1*gas + (2/5)nuclear >= 150

% Variables
var 0..2000: coal;
var 0..2000: gas;
var 0..2000: nuclear;

var 0..200000: total_cost;

% Constraints
constraint coal + gas + nuclear >= demand;

% Multiply by 10 to avoid fractions:
% 5*coal - 2*gas + 10*nuclear <= 2000
constraint 5*coal - 2*gas + 10*nuclear <= 10*measure1_max;

% Multiply by 5 to avoid fractions:
% 5*coal - 5*gas + 2*nuclear >= 750
constraint 5*coal - 5*gas + 2*nuclear >= 5*measure2_min;

constraint total_cost = cost_coal*coal + cost_gas*gas + cost_nuclear*nuclear;

% Objective
solve minimize total_cost;