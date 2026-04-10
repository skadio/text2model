% Parameters
int: max_total_packages = 500;        % Upper limit on total packages X+Y+Z
int: min_xy_sum = 200;               % Minimum required X+Y
int: yz_diff_limit = 150;            % |Y - Z| must not exceed this limit

int: cost_X = 50;                    % Cost per unit of package X
int: cost_Y = 30;                    % Cost per unit of package Y
int: cost_Z = 100;                   % Cost per unit of package Z

% Variables
var 0..max_total_packages: X;        % Number of package X (non-negative integer)
var 0..max_total_packages: Y;        % Number of package Y (non-negative integer)
var 0..max_total_packages: Z;        % Number of package Z (non-negative integer)

% Total cost (bounded integer)
var 0..(cost_X*max_total_packages + cost_Y*max_total_packages + cost_Z*max_total_packages): total_cost;

% Constraints

% --- Capacity constraint: total packages cannot exceed logistical limit ---
constraint X + Y + Z <= max_total_packages;

% --- Service requirement: ensure minimum combined offering of X and Y ---
constraint X + Y >= min_xy_sum;

% --- Preference constraint: X should not be less than half of Y (avoid division) ---
constraint 2 * X >= Y;

% --- Preference constraint: |Y - Z| must be within the allowed difference ---
constraint abs(Y - Z) <= yz_diff_limit;

% --- Total cost definition (linking variable total_cost to decision variables) ---
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;