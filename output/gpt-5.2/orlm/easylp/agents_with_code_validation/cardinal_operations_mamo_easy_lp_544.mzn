% Parameters
% Productivity score per hour for each task (x1,x2,x3)
array[1..3] of int: productivity = [8, 5, 6];

% Upper bounds (max hours) for each task (x1,x2,x3)
array[1..3] of int: ub = [30, 20, 15];

% Constraint 1: 2*x1 + 4*x2 + 3*x3 <= 40
array[1..3] of int: c1 = [2, 4, 3];
int: c1_rhs = 40;

% Constraint 2: x1 + (1/2)x2 - (1/4)x3 >= 10
% Use integer scaling by 4 to avoid fractions: 4*x1 + 2*x2 - 1*x3 >= 40
array[1..3] of int: c2 = [4, 2, -1];
int: c2_rhs = 40;

% Constraint 3: 2.5*x2 - (x1 + 0.75*x3) <= -20
% i.e., -x1 + 2.5*x2 - 0.75*x3 <= -20
% Use integer scaling by 4: -4*x1 + 10*x2 - 3*x3 <= -80
array[1..3] of int: c3 = [-4, 10, -3];
int: c3_rhs = -80;


% Variables
% Hours scheduled for each task (whole hours, non-negative, with given upper bounds)
% Use 0..max(ub) as a safe domain; individual upper bounds are enforced by constraints.
array[1..3] of var 0..30: hours;

% Total productivity score to minimize
var int: total_productivity;


% Constraints
% -----------------------
% Task hour upper bounds
% -----------------------
constraint
  forall(i in 1..3) (
    hours[i] <= ub[i]
  );

% -----------------------------------------
% Resource limitation: 2*x1 + 4*x2 + 3*x3 <= 40
% -----------------------------------------
constraint
  sum(i in 1..3) (c1[i] * hours[i]) <= c1_rhs;

% -------------------------------------------------------------
% Work-balance requirement (scaled by 4): 4*x1 + 2*x2 - x3 >= 40
% -------------------------------------------------------------
constraint
  sum(i in 1..3) (c2[i] * hours[i]) >= c2_rhs;

% -------------------------------------------------------------------
% Additional balance constraint (scaled by 4): -4*x1 + 10*x2 - 3*x3 <= -80
% -------------------------------------------------------------------
constraint
  sum(i in 1..3) (c3[i] * hours[i]) <= c3_rhs;

% -----------------------------------------
% Define total productivity score (for objective)
% -----------------------------------------
constraint
  total_productivity = sum(i in 1..3) (productivity[i] * hours[i]);


% Objective
solve minimize total_productivity;