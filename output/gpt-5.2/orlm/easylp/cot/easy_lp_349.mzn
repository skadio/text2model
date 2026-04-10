% Parameters (with values embedded)
int: costX = 30;
int: costY = 20;
int: costZ = 40;
int: costW = 50;

int: min_XY = 100;
int: max_ZW = 200;
int: min_XZ = 150;
int: max_diff_YW = 50;

% Variables
var 0..100000: X; % General Medicine resources
var 0..100000: Y; % Surgery resources
var 0..100000: Z; % Pediatrics resources
var 0..100000: W; % Geriatrics resources

var 0..100000000: total_cost;

% Constraints
constraint X + Y >= min_XY;
constraint Z + W <= max_ZW;
constraint X + Z >= min_XZ;
constraint abs(Y - W) <= max_diff_YW;

constraint total_cost = costX*X + costY*Y + costZ*Z + costW*W;

% Objective
solve minimize total_cost;