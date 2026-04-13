% Parameters (with values embedded)
int: anti_blue = 3;
int: min_blue  = 5;
int: sugar_blue = 5;

int: anti_straw = 1;
int: min_straw  = 7;
int: sugar_straw = 7;

int: req_anti = 90;
int: req_min  = 100;

int: ratio = 3; % strawberries at least 3x blueberries

% Variables
var 0..1000: blueberries;
var 0..1000: strawberries;
var 0..100000: total_sugar;

% Constraints
constraint anti_blue * blueberries + anti_straw * strawberries >= req_anti;
constraint min_blue  * blueberries + min_straw  * strawberries >= req_min;

constraint strawberries >= ratio * blueberries;

constraint total_sugar = sugar_blue * blueberries + sugar_straw * strawberries;

% Objective
solve minimize total_sugar;