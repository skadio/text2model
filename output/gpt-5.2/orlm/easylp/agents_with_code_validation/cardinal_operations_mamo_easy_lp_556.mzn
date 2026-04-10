% Parameters
% Fatigue coefficients (per unit effort)
int: c1 = 2; % strength conditioning
int: c2 = 3; % skill development
int: c3 = 5; % strategy and tactics

% Constraint constants
int: max_x1_x2 = 10;      % x1 + x2 <= 10
int: min_4x1_5x3 = 20;    % 4*x1 + 5*x3 >= 20
int: max_x3_minus_x2 = 5; % x3 - x2 <= 5

% Variable upper bounds (to keep variables bounded)
int: ub_x1 = 10; % from x1 + x2 <= 10 and nonnegativity
int: ub_x2 = 10; % from x1 + x2 <= 10 and nonnegativity
int: ub_x3 = 15; % from x3 - x2 <= 5 and x2 <= 10 => x3 <= 15

% Variables
var 0..ub_x1: x1; % effort units for strength conditioning (integer, nonnegative)
var 0..ub_x2: x2; % effort units for skill development (integer, nonnegative)
var 0..ub_x3: x3; % effort units for strategy and tactics (integer, nonnegative)

% Total fatigue (objective value), bounded by max possible within variable domains
var 0..(c1*ub_x1 + c2*ub_x2 + c3*ub_x3): total_fatigue;

% Constraints
% --- Time limitation: combined effort on strength and skill ---
constraint x1 + x2 <= max_x1_x2;

% --- Training requirement: minimum combined weighted effort of strength and strategy ---
constraint 4 * x1 + 5 * x3 >= min_4x1_5x3;

% --- Balance constraint: strategy minus skill not too large ---
constraint x3 - x2 <= max_x3_minus_x2;

% --- Strategy at least half of strength (avoid fractions) ---
constraint 2 * x3 >= x1;

% --- Define total fatigue as linear combination of efforts ---
constraint total_fatigue = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_fatigue;