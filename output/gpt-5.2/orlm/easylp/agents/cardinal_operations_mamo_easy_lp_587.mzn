% Parameters
% Number of projects
int: n = 4;

% Index set of projects (1..4 correspond to X1..X4)
set of int: PROJECTS = 1..n;

% Unit cost per project (X1..X4)
array[PROJECTS] of int: cost = [60, 50, 70, 80];

% Upper bounds for investments in each project (X1..X4); lower bounds are 0
array[PROJECTS] of int: ub = [400, 350, 250, 150];

% Group investment limits
int: max_x1_x2 = 500;   % X1 + X2 <= 500
int: max_x3_x4 = 300;   % X3 + X4 <= 300

% Minimum combined investment
int: min_x1_x3 = 200;   % X1 + X3 >= 200

% Strategic difference constraint constant:
% X2 - 0.5*X4 >= 100  <=>  2*X2 - X4 >= 200
int: min_x2_minus_half_x4 = 100;


% Variables
% Investment amounts in each project (X1..X4), integer and nonnegative
array[PROJECTS] of var int: x;

% Total cost to minimize
var int: total_cost;


% Constraints
%---------------------------------------------
% Variable domain / bounds constraints
%---------------------------------------------
constraint
  forall(p in PROJECTS) (
    0 <= x[p] /\ x[p] <= ub[p]
  );

%---------------------------------------------
% Group budget / technical limit constraints
%---------------------------------------------
constraint x[1] + x[2] <= max_x1_x2;   % X1 + X2 <= 500
constraint x[3] + x[4] <= max_x3_x4;   % X3 + X4 <= 300

%---------------------------------------------
% Minimum diversification / combined investment constraint
%---------------------------------------------
constraint x[1] + x[3] >= min_x1_x3;   % X1 + X3 >= 200

%---------------------------------------------
% Strategic difference constraint (avoid fractions)
% X2 - 0.5*X4 >= 100  <=>  2*X2 - X4 >= 200
%---------------------------------------------
constraint 2 * x[2] - x[4] >= 2 * min_x2_minus_half_x4;

%---------------------------------------------
% Total cost definition
%---------------------------------------------
constraint
  total_cost = sum(p in PROJECTS) (cost[p] * x[p]);


% Objective
solve minimize total_cost;