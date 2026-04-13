% Parameters
% Budget / portfolio constraints
int: max_XY = 100;      % X + Y <= 100
int: min_XZ = 150;      % X + Z >= 150
int: max_YZ = 200;      % Y + Z <= 200

% Unit costs (treated as costs to minimize)
int: cost_X = 3;        % cost per unit of X
int: cost_Y = 4;        % cost per unit of Y
int: cost_Z = 5;        % cost per unit of Z

% Variables
% Non-negative integer investments; bounds chosen to be consistent with constraints
var 0..max_XY: X;       % investment in project X
var 0..max_XY: Y;       % investment in project Y
var 0..max_YZ: Z;       % investment in project Z

% Constraints
% Budget constraint for projects X and Y
constraint X + Y <= max_XY;

% Minimum portfolio allocation constraint for projects X and Z
constraint X + Z >= min_XZ;

% Budget constraint for projects Y and Z
constraint Y + Z <= max_YZ;

% Objective
solve minimize cost_X * X + cost_Y * Y + cost_Z * Z;