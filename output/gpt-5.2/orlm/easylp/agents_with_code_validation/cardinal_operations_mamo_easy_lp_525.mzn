% Parameters
int: max_XY = 150;                 % Budget constraint: X + Y <= 150
int: min_XZ = 100;                 % Efficiency constraint: X + Z >= 100
int: max_abs_YZ = 60;              % Balance constraint: |Y - Z| <= 60
int: max_Z_minus_X = 10;           % Service quality: Z - X <= 10  (i.e., X >= Z - 10)

int: cost_X = 50;                  % Cost per unit for department X
int: cost_Y = 80;                  % Cost per unit for department Y
int: cost_Z = 30;                  % Cost per unit for department Z

% Variable bounds (nonnegative and bounded above using implied limits)
int: X_ub = max_XY;                % Since X <= X+Y <= 150
int: Y_ub = max_XY;                % Since Y <= X+Y <= 150
int: Z_ub = min_XZ + max_Z_minus_X;% From X+Z>=100 and Z-X<=10 -> Z <= 110

% Variables
var 0..X_ub: X;                    % Units allocated to patient care
var 0..Y_ub: Y;                    % Units allocated to research & development
var 0..Z_ub: Z;                    % Units allocated to administrative tasks

var 0..(cost_X*X_ub + cost_Y*Y_ub + cost_Z*Z_ub): total_cost; % Total cost ($)

% Constraints
%--- Budget constraint: patient care + R&D cannot exceed the allowed maximum
constraint
  X + Y <= max_XY;

%--- Efficiency constraint: patient care + admin must meet the minimum required
constraint
  X + Z >= min_XZ;

%--- Balance constraint: keep R&D and admin allocations within a bounded difference
constraint
  abs(Y - Z) <= max_abs_YZ;

%--- Service quality constraint: patient care not more than 10 units less than admin
constraint
  Z - X <= max_Z_minus_X;

%--- Total cost definition (linking variable total_cost to departmental allocations)
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;