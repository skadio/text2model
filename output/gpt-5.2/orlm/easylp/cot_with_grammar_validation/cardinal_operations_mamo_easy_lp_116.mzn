% Parameters
int: total_cap = 100;
int: max_X = 70;
int: max_Y = 50;

int: cost_X = 50;
int: cost_Y = 80;

int: min_offset = 10;     % X >= 2*Y + 10
int: diff_cap = 20;       % Y - X/2 <= 20  =>  2*Y - X <= 40

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..(cost_X*max_X + cost_Y*max_Y): total_cost;

% Constraints
constraint X + Y <= total_cap;

constraint X >= 2 * Y + min_offset;

constraint 2 * Y - X <= 2 * diff_cap;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;