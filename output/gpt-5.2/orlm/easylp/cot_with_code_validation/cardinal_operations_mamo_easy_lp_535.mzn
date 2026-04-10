% Parameters
int: LAND_MAX = 500;
int: MIN_DIVERSITY = 200;          % 2*X + Y >= 200
int: YZ_DIFF_MAX = 50;             % |Y - Z| <= 50
int: XZ_EXTRA_MIN = 100;           % X - Z >= 100 (from "at least twice that of half of Z" => X >= Z + 100)

int: COST_X = 100;
int: COST_Y = 50;
int: COST_Z = 75;

% Variables
var 0..LAND_MAX: X;
var 0..LAND_MAX: Y;
var 0..LAND_MAX: Z;

var 0..(COST_X*LAND_MAX + COST_Y*LAND_MAX + COST_Z*LAND_MAX): TotalCost;

% Constraints
constraint X + Y + Z <= LAND_MAX;

constraint 2*X + Y >= MIN_DIVERSITY;

constraint abs(Y - Z) <= YZ_DIFF_MAX;

constraint X - Z >= XZ_EXTRA_MIN;

constraint TotalCost = COST_X*X + COST_Y*Y + COST_Z*Z;

% Objective
solve minimize TotalCost;