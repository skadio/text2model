% Parameters
int: min_demand = 50;
int: max_overstock = 150;

int: profitX = 10;
int: profitY = 5;

% Variables
var 0..max_overstock: x;
var 0..max_overstock: y;

var 0..(profitX*max_overstock + profitY*max_overstock): total_profit;

% Constraints
constraint 2*x + y >= min_demand;
constraint x + 3*y <= max_overstock;

constraint total_profit = profitX*x + profitY*y;

% Objective
solve maximize total_profit;