% Parameters
% Budget limits
int: cap12 = 1000;   % maximum combined investment in X1 and X2
int: cap34 = 500;    % maximum combined investment in X3 and X4

% Return / risk thresholds (scaled to avoid decimals)
% 0.05*X1 + 0.07*X2 >= 50  <=>  5*X1 + 7*X2 >= 5000
int: min_return_scaled = 5000;

% -0.03*X3 + -0.04*X4 <= -20  <=>  3*X3 + 4*X4 >= 2000
int: min_risk_scaled = 2000;

% Unit costs
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Variables
var 0..cap12: x1;    % integer investment in asset X1
var 0..cap12: x2;    % integer investment in asset X2
var 0..cap34: x3;    % integer investment in asset X3
var 0..cap34: x4;    % integer investment in asset X4

% Total investment cost (upper bound derived from variable caps)
var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
% --- Budget cap constraints (combined investment limits) ---
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% --- Profitability constraint for (X1, X2) using scaled returns ---
% 5*X1 + 7*X2 >= 5000  (equivalent to 0.05*X1 + 0.07*X2 >= 50)
constraint 5 * x1 + 7 * x2 >= min_return_scaled;

% --- Risk / loss constraint for (X3, X4) using scaled inequality ---
% -0.03*X3 - 0.04*X4 <= -20  <=>  3*X3 + 4*X4 >= 2000
constraint 3 * x3 + 4 * x4 >= min_risk_scaled;

% --- Total cost definition (linking total_cost to decision variables) ---
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;