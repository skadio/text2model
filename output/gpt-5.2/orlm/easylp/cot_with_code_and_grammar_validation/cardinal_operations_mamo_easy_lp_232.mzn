% Parameters
int: TOTAL_RESOURCE = 1000;
int: MIN_YIELD_XY = 3000;
int: MIN_Z_MINUS_3Y = -500;

int: coef_X_resource = 1;
int: coef_Y_resource = 1;
int: coef_Z_resource = 1;

int: coef_X_yield = 4;
int: coef_Y_yield = 5;

int: coef_Z_constraint = 1;
int: coef_Y_constraint = -3;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..TOTAL_RESOURCE: X;
var 0..TOTAL_RESOURCE: Y;
var 0..TOTAL_RESOURCE: Z;

var 0..(cost_X*TOTAL_RESOURCE + cost_Y*TOTAL_RESOURCE + cost_Z*TOTAL_RESOURCE): total_cost;

% Constraints
constraint X + Y + Z <= TOTAL_RESOURCE;

constraint coef_X_yield * X + coef_Y_yield * Y >= MIN_YIELD_XY;

constraint Z - 3 * Y >= MIN_Z_MINUS_3Y;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;