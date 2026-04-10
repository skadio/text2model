% Parameters (with values embedded)
int: support_X = 50;
int: support_Y = 75;

int: min_strength = 60;         % 2*X + 1*Y >= 60
int: max_logistics = 120;       % 1*X + 3*Y <= 120

% Variable bounds derived from constraints:
% From 2*X + Y >= 60 and nonnegativity -> X <= 60, Y <= 120 (safe), but tighten:
% From X + 3Y <= 120 -> X <= 120, Y <= 40
int: X_ub = 60;
int: Y_ub = 40;

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;

% Constraints
constraint 2 * X + 1 * Y >= min_strength;
constraint 1 * X + 3 * Y <= max_logistics;

% Objective
var int: total_support = support_X * X + support_Y * Y;
solve minimize total_support;