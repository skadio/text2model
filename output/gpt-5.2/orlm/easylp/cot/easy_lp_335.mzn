% Parameters (with values embedded)
int: demand_min = 1000;

int: cost_coal = 50;
int: cost_gas = 60;
int: cost_solar = 70;
int: cost_nuclear = 80;

int: coal_reg_max = 500;          % emission regulation cap
int: coal_min = 0;
int: coal_max = 600;

int: gas_min = 0;
int: gas_max = 400;

int: solar_min = 300;
int: solar_max = 10000;          % no explicit upper bound given; use a safe large bound

int: nuclear_min = 100;
int: nuclear_max = 10000;        % no explicit upper bound given; use a safe large bound

int: solar_minus_nuclear_min = 200;
int: gas_solar_diff_max = 150;

% Variables
var coal_min..coal_max: Coal;
var gas_min..gas_max: Gas;
var solar_min..solar_max: Solar;
var nuclear_min..nuclear_max: Nuclear;

var int: TotalCost;

% Constraints
constraint Coal <= coal_reg_max;

constraint Coal + Gas + Solar + Nuclear >= demand_min;

constraint Solar - Nuclear >= solar_minus_nuclear_min;

constraint abs(Gas - Solar) <= gas_solar_diff_max;

constraint TotalCost = cost_coal * Coal
                     + cost_gas * Gas
                     + cost_solar * Solar
                     + cost_nuclear * Nuclear;

% Objective
solve minimize TotalCost;