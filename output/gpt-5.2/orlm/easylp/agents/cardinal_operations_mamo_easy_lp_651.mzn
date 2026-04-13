% Parameters
include "globals.mzn";

% Unit investment costs for each property type (x1..x4)
array[1..4] of int: cost = [500, 300, 200, 100];

% Limits on combined investments
int: max_x1_x2 = 50;   % x1 + x2 <= 50
int: max_x3_x4 = 70;   % x3 + x4 <= 70

% ROI constraint coefficients (scaled by 20 to keep everything integer)
% ROI: 0.5*x1 - 0.25*x2 + 0.15*x3 + 1.0*x4 >= 20
% Multiply by 20: 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
array[1..4] of int: roi_coef_scaled = [10, -5, 3, 20];
int: roi_rhs_scaled = 400;

% Diversification/risk constraint coefficients (scaled by 4 to keep integer)
% Risk: 2.5*x2 + 0.75*x3 - x1 - x4 <= 30
% Multiply by 4: 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
array[1..4] of int: risk_coef_scaled = [-4, 10, 3, -4];
int: risk_rhs_scaled = 120;


% Variables
% Integer investment units in each property type; nonnegative
array[1..4] of var int: x;

% Total cost (bounded explicitly)
var 0..(max_x1_x2 * max(cost) + max_x3_x4 * max(cost)): total_cost;


% Constraints

% -----------------------------
% Nonnegativity (integer units)
% -----------------------------
constraint forall(i in 1..4)(
  x[i] >= 0
);

% ---------------------------------
% Combined investment limit blocks
% ---------------------------------
constraint
  x[1] + x[2] <= max_x1_x2;   % Residential + Commercial <= 50

constraint
  x[3] + x[4] <= max_x3_x4;   % Industrial + Recreational <= 70

% -----------------------
% ROI feasibility block
% (scaled by 20 already)
% -----------------------
constraint
  sum(i in 1..4)(roi_coef_scaled[i] * x[i]) >= roi_rhs_scaled;

% --------------------------------------
% Diversification / risk feasibility block
% (scaled by 4 already)
% --------------------------------------
constraint
  sum(i in 1..4)(risk_coef_scaled[i] * x[i]) <= risk_rhs_scaled;

% --------------------
% Total cost definition
% --------------------
constraint
  total_cost = sum(i in 1..4)(cost[i] * x[i]);


% Objective
solve minimize total_cost;