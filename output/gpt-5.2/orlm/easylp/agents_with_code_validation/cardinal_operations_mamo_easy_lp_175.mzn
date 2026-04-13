% Parameters
% Budget/portfolio constraints
int: max_XY = 100;      % X + Y <= 100
int: min_XZ = 150;      % X + Z >= 150
int: max_YZ = 200;      % Y + Z <= 200

% Unit costs (or cost coefficients)
int: cost_X = 3;
int: cost_Y = 4;
int: cost_Z = 5;

% Variables
var 0..max_XY: X;        % investment in project X (non-negative integer)
var 0..max_XY: Y;        % investment in project Y (non-negative integer)

% From X + Z >= 150 and X >= 0 => Z >= 150
% From Y + Z <= 200 and Y >= 0 => Z <= 200
var min_XZ..max_YZ: Z;   % investment in project Z (integer)

var int: total_cost;     % total investment cost

% Constraints
% Budget constraint: total investment in X and Y cannot exceed max_XY
constraint X + Y <= max_XY;

% Portfolio balance constraint: investment in X and Z must be at least min_XZ
constraint X + Z >= min_XZ;

% Budget constraint: total investment in Y and Z cannot exceed max_YZ
constraint Y + Z <= max_YZ;

% Define total cost from unit costs and investment levels
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;