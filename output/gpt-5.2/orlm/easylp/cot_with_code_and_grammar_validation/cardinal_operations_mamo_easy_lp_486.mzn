% Parameters
int: costX = 5;
int: costY = 8;

int: maxR1 = 50;          % X + 2Y <= 50
int: minTotal = 10;       % X + Y >= 10
int: maxDiff = 20;        % Y - (X/2) <= 20  ->  2Y - X <= 40

int: X_lb = 0;
int: X_ub = 25;
int: Y_lb = 0;
int: Y_ub = 30;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;

% Constraints
constraint X + 2*Y <= maxR1;
constraint X + Y >= minTotal;
constraint 2*Y - X <= 2*maxDiff;

% Objective
solve minimize costX * X + costY * Y;