% Parameters (with values embedded)
int: min_demand = 50;          % 2*X + Y >= 50
int: max_overstock = 150;      % X + 3*Y <= 150
int: profitX = 10;
int: profitY = 5;

% Upper bounds derived from constraints:
% From 2*X + Y >= 50 and nonnegativity -> X <= 75, Y <= 150
% From X + 3*Y <= 150 -> X <= 150, Y <= 50
int: ubX = 75;
int: ubY = 50;

% Variables
var 0..ubX: x;   % units of product X (integer, nonnegative)
var 0..ubY: y;   % units of product Y (integer, nonnegative)
var int: total_profit;

% Constraints
constraint 2*x + y >= min_demand;
constraint x + 3*y <= max_overstock;

constraint total_profit = profitX * x + profitY * y;

% Objective
solve maximize total_profit;