% Parameters
int: max_XY = 1000;                 % Budget constraint: X + Y <= 1000
int: min_YZ = 500;                  % Output constraint: Y + Z >= 500
int: max_diff_XZ = 200;             % Balance constraint: |X - Z| <= 200

int: cost_X = 4;                    % Unit cost for procurement stage X
int: cost_Y = 3;                    % Unit cost for manufacturing stage Y
int: cost_Z = 2;                    % Unit cost for distribution stage Z

% Variables
var 0..max_XY: X;                   % Resource allocation to stage X (non-negative integer)
var 0..max_XY: Y;                   % Resource allocation to stage Y (non-negative integer)
var 0..(max_XY + min_YZ): Z;        % Resource allocation to stage Z (safe upper bound)

var int: total_cost;                % Total cost to minimize (integer)

% Constraints
% --- Budget constraint: procurement + manufacturing within budget ---
constraint X + Y <= max_XY;

% --- Minimum output/throughput constraint: manufacturing + distribution sufficient ---
constraint Y + Z >= min_YZ;

% --- Balance constraint: keep procurement and distribution allocations close ---
constraint abs(X - Z) <= max_diff_XZ;

% --- Total cost definition (linear expression, integer) ---
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;