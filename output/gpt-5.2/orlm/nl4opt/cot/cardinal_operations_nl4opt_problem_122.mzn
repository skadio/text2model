% Parameters (with values embedded)
int: budget = 760000;
float: profit_condo = 0.50;
float: profit_detached = 1.0;
float: min_condo_fraction = 0.20;
int: min_detached_investment = 20000;

% Variables
var 0..budget: condo_investment;
var 0..budget: detached_investment;
var float: total_profit;

% Constraints
constraint condo_investment + detached_investment <= budget;
constraint condo_investment >= min_condo_fraction * (condo_investment + detached_investment);
constraint detached_investment >= min_detached_investment;

constraint total_profit = profit_condo * int2float(condo_investment)
                        + profit_detached * int2float(detached_investment);

% Objective
solve maximize total_profit;