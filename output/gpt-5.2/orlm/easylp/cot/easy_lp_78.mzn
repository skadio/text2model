% Parameters (with values embedded)
int: reqA = 8;          % 2*X + Y >= 8
int: limitB = 15;       % X + 3*Y <= 15
int: costX = 5000;      % dollars per worker on Project X
int: costY = 3000;      % dollars per worker on Project Y

% Variables
var 0..limitB: X;       % number of workers on Project X (integer, nonnegative)
var 0..limitB: Y;       % number of workers on Project Y (integer, nonnegative)
var 0..(costX*limitB + costY*limitB): TotalCost;

% Constraints
constraint 2*X + Y >= reqA;
constraint X + 3*Y <= limitB;
constraint TotalCost = costX*X + costY*Y;

% Objective
solve minimize TotalCost;