% Parameters
%------------------------------------------------------------
% Productivity score per hour for each task (x1, x2, x3)
%------------------------------------------------------------
array[1..3] of int: productivity = [8, 5, 6];

%------------------------------------------------------------
% Upper bounds on hours for each task (x1, x2, x3)
%------------------------------------------------------------
array[1..3] of int: max_hours = [30, 20, 15];

%------------------------------------------------------------
% Coefficients and RHS for constraints
% 1) 2*x1 + 4*x2 + 3*x3 <= 40
%------------------------------------------------------------
array[1..3] of int: c1 = [2, 4, 3];
int: rhs1 = 40;

%------------------------------------------------------------
% 2) x1 + 0.5*x2 - 0.25*x3 >= 10
%------------------------------------------------------------
array[1..3] of float: c2 = [1.0, 0.5, -0.25];
float: rhs2 = 10.0;

%------------------------------------------------------------
% 3) -1*x1 + 2.5*x2 - 0.75*x3 <= -20
%------------------------------------------------------------
array[1..3] of float: c3 = [-1.0, 2.5, -0.75];
float: rhs3 = -20.0;


% Variables
%------------------------------------------------------------
% Hours assigned to each task (whole hours, nonnegative)
% Domain is set wide enough; actual per-task maxima enforced by constraints.
%------------------------------------------------------------
array[1..3] of var 0..30: x;

% Total productivity score to minimize
var int: total_productivity;


% Constraints
%------------------------------------------------------------
% Per-task hour upper bounds (respect individual maxima)
%------------------------------------------------------------
constraint
  forall(i in 1..3) (
    x[i] <= max_hours[i]
  );

%------------------------------------------------------------
% Define total productivity from per-hour productivity scores
%------------------------------------------------------------
constraint
  total_productivity = sum(i in 1..3)(productivity[i] * x[i]);

%------------------------------------------------------------
% Resource / capacity constraint: 2*x1 + 4*x2 + 3*x3 <= 40
%------------------------------------------------------------
constraint
  sum(i in 1..3)(c1[i] * x[i]) <= rhs1;

%------------------------------------------------------------
% Balance constraint (fractional coefficients): x1 + 0.5*x2 - 0.25*x3 >= 10
% Use int2float to ensure type consistency with float coefficients/RHS
%------------------------------------------------------------
constraint
  sum(i in 1..3)(c2[i] * int2float(x[i])) >= rhs2;

%------------------------------------------------------------
% Interaction constraint (fractional coefficients): -x1 + 2.5*x2 - 0.75*x3 <= -20
% Use int2float to ensure type consistency with float coefficients/RHS
%------------------------------------------------------------
constraint
  sum(i in 1..3)(c3[i] * int2float(x[i])) <= rhs3;


% Objective
solve minimize total_productivity;