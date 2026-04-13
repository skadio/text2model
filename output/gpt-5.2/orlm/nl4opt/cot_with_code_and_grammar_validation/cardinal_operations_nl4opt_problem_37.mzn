% Parameters
int: shaping_thin = 50;
int: baking_thin  = 90;
int: shaping_stubby = 30;
int: baking_stubby  = 150;

int: shaping_available = 3000;
int: baking_available  = 4000;

int: profit_thin = 5;
int: profit_stubby = 9;

% Variables
var 0..(shaping_available div shaping_thin): thin;
var 0..(shaping_available div shaping_stubby): stubby;

var int: total_profit;

% Constraints
constraint shaping_thin * thin + shaping_stubby * stubby <= shaping_available;
constraint baking_thin  * thin + baking_stubby  * stubby <= baking_available;

constraint total_profit = profit_thin * thin + profit_stubby * stubby;

% Objective
solve maximize total_profit;