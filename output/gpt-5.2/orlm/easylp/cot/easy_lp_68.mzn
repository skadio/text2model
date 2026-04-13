% Parameters (with values embedded)
int: max_acres = 50;
int: min_total_acres = 40;

int: costX = 5;
int: costY = 10;

% Variables
var 0..max_acres: X;  % acres of crop X (integer)
var 0..max_acres: Y;  % acres of crop Y (integer)

% Constraints
constraint X + Y <= max_acres;
constraint X + Y >= min_total_acres;

% at least twice as much X as Y
constraint X >= 2 * Y;

% X cannot exceed twice Y by more than 10 acres: X - 2Y <= 10
constraint X - 2 * Y <= 10;

% Objective
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;