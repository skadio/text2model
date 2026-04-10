% Parameters (with values embedded)
int: costX = 5;
int: costY = 10;
int: minQuota = 200;        % 2*X + Y >= 200
int: maxCapacity = 150;     % X + 3*Y <= 150

% Variables
var 0..200: X;  % upper bound safe from constraints (since 2*X + Y >= 200 implies X <= 200 if Y >= 0)
var 0..200: Y;

% Constraints
constraint 2*X + Y >= minQuota;
constraint X + 3*Y <= maxCapacity;

% Objective
solve minimize costX*X + costY*Y;