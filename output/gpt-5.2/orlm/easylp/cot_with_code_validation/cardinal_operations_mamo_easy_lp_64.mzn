% Parameters
int: costX = 500;
int: costY = 700;

int: perfReq = 2000;          % required minimum combined effort
int: maxTotalRes = 1500;      % maximum total resources

int: coefX = 2;
int: coefY = 3;

% Variables
var 0..maxTotalRes: x;        % resources allocated to Project X (integer, nonnegative)
var 0..maxTotalRes: y;        % resources allocated to Project Y (integer, nonnegative)

var 0..(costX*maxTotalRes + costY*maxTotalRes): totalCost;

% Constraints
constraint coefX * x + coefY * y >= perfReq;
constraint x + y <= maxTotalRes;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;