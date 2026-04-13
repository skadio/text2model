% Parameters
% Budget/operational limits
int: max_XY = 150;          % X + Y cannot exceed this
int: min_XZ = 100;          % X + Z must be at least this
int: max_diff_YZ = 60;      % |Y - Z| cannot exceed this
int: max_Z_minus_X = 10;    % Z - X <= 10  (i.e., X is not more than 10 less than Z)

% Unit costs (dollars per unit)
int: cost_X = 50;
int: cost_Y = 80;
int: cost_Z = 30;

% Variables
var 0..max_XY: X;                         % units allocated to patient care
var 0..max_XY: Y;                         % units allocated to research & development
var 0..(max_XY + max_Z_minus_X): Z;       % units allocated to administrative tasks (bounded for safety)

% Constraints
% --- Budget constraint: patient care + R&D cannot exceed the maximum allowed ---
constraint X + Y <= max_XY;

% --- Operational minimum: patient care + administration must be at least the required minimum ---
constraint X + Z >= min_XZ;

% --- Balance constraint: difference between R&D and administration is bounded ---
constraint abs(Y - Z) <= max_diff_YZ;

% --- Service quality constraint: X is not more than 10 units less than Z (i.e., Z - X <= 10) ---
constraint Z - X <= max_Z_minus_X;

% Objective
solve minimize cost_X * X + cost_Y * Y + cost_Z * Z;