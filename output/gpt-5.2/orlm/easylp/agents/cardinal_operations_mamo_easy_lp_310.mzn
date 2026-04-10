% Parameters
int: max_units = 100;                 % Maximum total units supported
int: strength_X_coeff = 5;            % Strength coefficient for X in mission constraint
int: strength_Y_coeff = 3;            % Strength coefficient for Y in mission constraint
int: min_required_strength = 50;      % Minimum required combined strength
int: max_diff_ZY = 30;                % Maximum allowed absolute difference between Z and Y
int: cost_X = 500;                    % Support points per unit of X
int: cost_Y = 600;                    % Support points per unit of Y
int: cost_Z = 700;                    % Support points per unit of Z

% Variables
var 0..max_units: x_units;            % Number of X units
var 0..max_units: y_units;            % Number of Y units
var 0..max_units: z_units;            % Number of Z units
var 0..(cost_Z*max_units): total_support_points;  % Total support points (objective)

% Constraints
% Total unit capacity (logistical constraint)
constraint x_units + y_units + z_units <= max_units;

% Mission strength requirement (5*X + 3*Y >= 50)
constraint strength_X_coeff * x_units + strength_Y_coeff * y_units >= min_required_strength;

% Operational balance between Z and Y (|Z - Y| <= 30)
constraint abs(z_units - y_units) <= max_diff_ZY;

% Define total support points from unit allocations
constraint total_support_points = cost_X * x_units + cost_Y * y_units + cost_Z * z_units;

% Objective
solve minimize total_support_points;