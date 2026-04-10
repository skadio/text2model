% Parameters
%-----------------------------
% Resource allocation bounds
%-----------------------------
int: X_min = 0;
int: X_max = 50;
int: Y_min = 0;
int: Y_max = 30;
int: Z_min = 0;              % No upper bound specified for Z (non-negative only)

%-----------------------------
% Budget / allocation limits
%-----------------------------
int: total_alloc_max = 100;  % X + Y + Z <= 100
int: YZ_alloc_max = 70;      % Y + Z <= 70

%-----------------------------
% Relationship constraint parameter
%-----------------------------
int: X_extra_over_2Y = 10;   % X >= 2*Y + 10

%-----------------------------
% Unit costs
%-----------------------------
int: cost_X = 3;
int: cost_Y = 2;
int: cost_Z = 5;


% Variables
%-----------------------------
% Decision variables (integer allocations)
%-----------------------------
var X_min..X_max: X;         % Units allocated to project X
var Y_min..Y_max: Y;         % Units allocated to project Y
var int: Z;                  % Units allocated to project Z (bounded by constraints)

%-----------------------------
% Objective-related variable
%-----------------------------
var int: total_cost;         % Total cost = 3X + 2Y + 5Z


% Constraints
%-----------------------------
% Non-negativity / domain for Z
%-----------------------------
constraint Z >= Z_min;

%-----------------------------
% Allocation capacity constraints
%-----------------------------
constraint X + Y + Z <= total_alloc_max;     % Total allocation limit
constraint Y + Z <= YZ_alloc_max;            % Combined Y and Z allocation limit

%-----------------------------
% Inter-project relationship constraint
%-----------------------------
constraint X >= 2 * Y + X_extra_over_2Y;     % X at least 10 more than twice Y

%-----------------------------
% Total cost definition
%-----------------------------
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;


% Objective
solve minimize total_cost;