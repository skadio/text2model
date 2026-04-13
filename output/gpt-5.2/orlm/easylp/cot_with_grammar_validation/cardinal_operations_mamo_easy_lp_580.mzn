% Parameters
int: BUDGET = 1000;
int: RES_MINUS_COM_MIN = 50;
int: IND_RES_DIFF_MAX = 200;
int: COM_MINUS_IND_MIN = 30;

int: COST_RES = 200;
int: COST_COM = 150;
int: COST_IND = 300;

% Variables
var 0..BUDGET: X; % residential
var 0..BUDGET: Y; % commercial
var 0..BUDGET: Z; % industrial

var 0..(BUDGET * max([COST_RES, COST_COM, COST_IND])): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X >= Y + RES_MINUS_COM_MIN;

constraint abs(Z - X) <= IND_RES_DIFF_MAX;

constraint Y >= Z + COM_MINUS_IND_MIN;

constraint total_cost = COST_RES * X + COST_COM * Y + COST_IND * Z;

% Objective
solve minimize total_cost;