% Parameters
int: maxXY = 5000;
int: maxZW = 2000;

int: minXminusZ = 1000;
int: minYminusW = 1500;

int: maxX = 4000;
int: maxY = 3000;
int: minZ = 500;
int: minW = 200;

int: costX = 20;
int: costY = 30;
int: costZ = 50;
int: costW = 10;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var minZ..2000: z;   % bounded by minZ and maxZW
var minW..2000: w;   % bounded by minW and maxZW

var int: total_cost;

% Constraints
constraint x + y <= maxXY;
constraint z + w <= maxZW;

constraint x - z >= minXminusZ;
constraint y - w >= minYminusW;

constraint total_cost = costX * x + costY * y + costZ * z + costW * w;

% Objective
solve minimize total_cost;