% Parameters
% Total available resources (budget in units)
int: total_resources = 1000;

% Cost per unit resource for each initiative
int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 4;

% Constraint constants
int: min_extra_X_over_2Y = 100;   % X >= 2*Y + 100
int: max_diff_YZ = 50;            % |Y - Z| <= 50
int: min_X_plus_Z = 300;          % X + Z >= 300

% Operational/strategic bounds on allocations
% (Not numerically specified in the text; assume nonnegativity and budget upper bound)
int: X_lb = 0; int: X_ub = total_resources;
int: Y_lb = 0; int: Y_ub = total_resources;
int: Z_lb = 0; int: Z_ub = total_resources;

% Variables
var X_lb..X_ub: X;  % resources allocated to initiative X
var Y_lb..Y_ub: Y;  % resources allocated to initiative Y
var Z_lb..Z_ub: Z;  % resources allocated to initiative Z

var int: total_cost; % objective: total cost

% Constraints
%-------------------------------
% Resource budget constraint
%-------------------------------
constraint
  X + Y + Z <= total_resources;

%-------------------------------
% Initiative relationship constraints
%-------------------------------

% X must be at least 100 more than twice Y: X >= 2*Y + 100
constraint
  X >= 2 * Y + min_extra_X_over_2Y;

% Y and Z must be balanced: |Y - Z| <= 50
constraint
  abs(Y - Z) <= max_diff_YZ;

% Minimum combined commitment to X and Z: X + Z >= 300
constraint
  X + Z >= min_X_plus_Z;

%-------------------------------
% Cost calculation constraint
%-------------------------------
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;