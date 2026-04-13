% Parameters
int: budget_max = 1000;                 % Maximum total funding allowed
int: min_2x_plus_y = 400;               % Minimum required for (2*X + Y)
int: min_y_plus_z = 500;                % Minimum required for (Y + Z)

int: benefit_x = 5;                     % Benefit units per dollar in X
int: benefit_y = 3;                     % Benefit units per dollar in Y
int: benefit_z = 1;                     % Benefit units per dollar in Z

int: x_lb = 0; int: x_ub = 600;         % Bounds for funding in X
int: y_lb = 0; int: y_ub = 400;         % Bounds for funding in Y
int: z_lb = 0; int: z_ub = 300;         % Bounds for funding in Z


% Variables
var x_lb..x_ub: fund_x;                 % Whole-dollar funding allocated to program X
var y_lb..y_ub: fund_y;                 % Whole-dollar funding allocated to program Y
var z_lb..z_ub: fund_z;                 % Whole-dollar funding allocated to program Z

var 0..budget_max: total_funding;       % Total funding across X, Y, Z (bounded by budget)

% Total benefit variable (not optimized, but tracked)
var 0..(benefit_x*x_ub + benefit_y*y_ub + benefit_z*z_ub): total_benefit;


% Constraints
% --- Funding aggregation ---
constraint total_funding = fund_x + fund_y + fund_z;

% Enforce overall budget cap (explicit; also implied by total_funding domain)
constraint total_funding <= budget_max;

% --- Minimum investment requirements ---
constraint 2 * fund_x + fund_y >= min_2x_plus_y;
constraint fund_y + fund_z >= min_y_plus_z;

% --- Benefit accounting (tracked) ---
constraint total_benefit = benefit_x * fund_x + benefit_y * fund_y + benefit_z * fund_z;


% Objective
solve minimize total_funding;