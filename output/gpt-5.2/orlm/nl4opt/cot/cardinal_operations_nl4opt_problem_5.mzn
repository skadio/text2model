% Parameters (with values embedded)
float: profit_hardwood = 2.5;
float: profit_vinyl = 3.0;

int: demand_hardwood_min = 20000;
int: demand_vinyl_min = 10000;

int: ship_total_min = 60000;

int: hardwood_max = 50000;
int: vinyl_max = 30000;

% Variables
var 0..hardwood_max: hardwood_sqft;
var 0..vinyl_max: vinyl_sqft;
var float: total_profit;

% Constraints
constraint hardwood_sqft >= demand_hardwood_min;
constraint vinyl_sqft >= demand_vinyl_min;

constraint hardwood_sqft + vinyl_sqft >= ship_total_min;

constraint total_profit = profit_hardwood * hardwood_sqft + profit_vinyl * vinyl_sqft;

% Objective
solve maximize total_profit;