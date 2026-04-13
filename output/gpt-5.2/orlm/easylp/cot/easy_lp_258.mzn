% Parameters (with values embedded)
int: BUDGET_MAX = 1000;
int: EFFECT_MIN = 800;
int: DIFF_MAX = 300;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: effX = 3;
int: effY = 2;
int: effZ = 1;

% Variables
var 0..BUDGET_MAX: X; % purchasing investment
var 0..BUDGET_MAX: Y; % manufacturing investment
var 0..BUDGET_MAX: Z; % distribution investment

var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint effX*X + effY*Y + effZ*Z >= EFFECT_MIN;

constraint X - Y <= DIFF_MAX;
constraint Y - X <= DIFF_MAX;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;