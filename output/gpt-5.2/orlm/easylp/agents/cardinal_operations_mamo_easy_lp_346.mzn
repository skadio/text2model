% Parameters
% Risk coefficients for portfolios x1..x4
int: risk_x1 = 5;
int: risk_x2 = 7;
int: risk_x3 = 6;
int: risk_x4 = 8;

% Constraint coefficients and RHS values
int: a11 = 3;  int: a12 = 4;  int: b1 = 5000;   % 3*x1 + 4*x2 <= 5000
int: a21 = 2;  int: a23 = 5;  int: b2 = 6000;   % 2*x1 + 5*x3 <= 6000
int: min_diff_24 = 1000;                         % x2 - x4 >= 1000
int: a41 = 1;  int: a43 = 3;  int: b4 = 2000;   % x1 - 3*x3 <= 2000

% Bounds on allocations (non-negativity)
int: lb = 0;

% Variables
var int: x1; % dollars invested in portfolio 1
var int: x2; % dollars invested in portfolio 2
var int: x3; % dollars invested in portfolio 3
var int: x4; % dollars invested in portfolio 4

var int: total_risk; % objective value: 5*x1 + 7*x2 + 6*x3 + 8*x4

% Constraints
% Explicit non-negativity bounds
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;

% Objective definition (linear expression for total risk)
constraint total_risk = risk_x1*x1 + risk_x2*x2 + risk_x3*x3 + risk_x4*x4;

% Budget/scale constraint for portfolios x1 and x2: 3*x1 + 4*x2 <= 5000
constraint a11 * x1 + a12 * x2 <= b1;

% Budget/yield constraint for portfolios x1 and x3: 2*x1 + 5*x3 <= 6000
constraint a21 * x1 + a23 * x3 <= b2;

% Diversification constraint between portfolios x2 and x4: x2 - x4 >= 1000
constraint x2 - x4 >= min_diff_24;

% Balance constraint between x1 and x3: x1 - 3*x3 <= 2000
constraint a41 * x1 - a43 * x3 <= b4;

% Objective
solve minimize total_risk;