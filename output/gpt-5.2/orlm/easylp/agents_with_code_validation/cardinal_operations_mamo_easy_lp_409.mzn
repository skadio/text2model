% Parameters
int: max_x1 = 20;            % Maximum residential units
int: max_x2 = 30;            % Maximum commercial units
int: max_x3 = 15;            % Maximum industrial units
int: max_x4 = 10;            % Maximum retail units

int: cost_x1 = 200000;       % Cost per residential unit ($)
int: cost_x2 = 300000;       % Cost per commercial unit ($)
int: cost_x3 = 500000;       % Cost per industrial unit ($)
int: cost_x4 = 700000;       % Cost per retail unit ($)

int: cap_x1_x2 = 50;         % Constraint: x1 + x2 <= 50
int: min_2x3_x4 = 60;        % Constraint: 2*x3 + x4 >= 60

% Use integer-scaled coefficients to avoid floats:
% 3*x1 + 4.5*x2 <= 100  ==>  6*x1 + 9*x2 <= 200
int: rhs_3x1_4p5x2 = 100;
int: rhs_scaled_3x1_4p5x2 = 2 * rhs_3x1_4p5x2;  % 200

% 6*x3 - 0.5*x4 <= 80  ==>  12*x3 - x4 <= 160
int: rhs_6x3_m0p5x4 = 80;
int: rhs_scaled_6x3_m0p5x4 = 2 * rhs_6x3_m0p5x4; % 160


% Variables
var 0..max_x1: x1;           % Residential units (integer)
var 0..max_x2: x2;           % Commercial units (integer)
var 0..max_x3: x3;           % Industrial units (integer)
var 0..max_x4: x4;           % Retail units (integer)

var int: total_cost;         % Total investment cost ($)


% Constraints
% Domain/upper-bound constraints are already enforced by variable declarations (0..max_xi)

% --- Zoning/budget interaction constraints ---
constraint x1 + x2 <= cap_x1_x2;                 % Residential + Commercial cannot exceed 50
constraint 2 * x3 + x4 >= min_2x3_x4;            % Twice Industrial plus Retail must be at least 60

% Scaled to avoid fractional coefficient: 3*x1 + 4.5*x2 <= 100  <=>  6*x1 + 9*x2 <= 200
constraint 6 * x1 + 9 * x2 <= rhs_scaled_3x1_4p5x2;

% Scaled to avoid fractional coefficient: 6*x3 - 0.5*x4 <= 80  <=>  12*x3 - x4 <= 160
constraint 12 * x3 - x4 <= rhs_scaled_6x3_m0p5x4;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;