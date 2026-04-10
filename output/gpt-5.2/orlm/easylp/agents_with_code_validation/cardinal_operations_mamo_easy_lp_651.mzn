% Parameters
int: nProps = 4;                         % number of property types
set of int: PROPS = 1..nProps;           % index set for properties

array[PROPS] of int: cost = [500,300,200,100];   % unit costs for x1..x4

int: max_x1_x2 = 50;                     % x1 + x2 <= 50
int: max_x3_x4 = 70;                     % x3 + x4 <= 70

% To model fractional coefficients exactly, scale constraints to integers:
% ROI constraint: (1/2)x1 - (1/4)x2 + 0.15x3 + 1*x4 >= 20
% Multiply by 20 => 10x1 - 5x2 + 3x3 + 20x4 >= 400
int: roi_scale = 20;
int: roi_rhs_scaled = 400;

% Diversification constraint:
% 2.5x2 + 0.75x3 - x1 - x4 <= 30
% Multiply by 4 => 10x2 + 3x3 - 4x1 - 4x4 <= 120
int: div_scale = 4;
int: div_rhs_scaled = 120;

% Variables
array[PROPS] of var int: x;              % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4 (integer units)
var int: total_cost;                     % total investment cost (in dollars)

% Constraints

% --- Domain / feasibility constraints (nonnegative integer investments) ---
constraint
  forall(p in PROPS) (
    x[p] >= 0
  );

% --- Budget / capacity-style constraints on grouped property counts ---
constraint
  x[1] + x[2] <= max_x1_x2;     % x1 + x2 <= 50

constraint
  x[3] + x[4] <= max_x3_x4;     % x3 + x4 <= 70

% --- ROI constraint (scaled by roi_scale=20 to keep integer coefficients) ---
constraint
  10*x[1] - 5*x[2] + 3*x[3] + 20*x[4] >= roi_rhs_scaled;  % >= 400

% --- Diversification / risk constraint (scaled by div_scale=4) ---
constraint
  10*x[2] + 3*x[3] - 4*x[1] - 4*x[4] <= div_rhs_scaled;   % <= 120

% --- Define total cost from unit costs ---
constraint
  total_cost = sum(p in PROPS) (cost[p] * x[p]);

% Objective
solve minimize total_cost;