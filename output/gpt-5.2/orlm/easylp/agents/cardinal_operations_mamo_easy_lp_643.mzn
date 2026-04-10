% Parameters
% Project index set
set of int: PROJECTS = 1..4;

% Cost per unit resource for each project: [X1,X2,X3,X4]
array[PROJECTS] of int: cost = [4, 2, 3, 5];

% Constraint constants (all given in the statement)
int: c1_rhs = 100;   % |0.5*X2 - X1| <= 100
int: c2_rhs = 200;   % X1 >= 200 + 0.7*X3
int: c3_rhs = 150;   % |X4 - 0.6*X2| <= 150
int: c4_rhs = 300;   % |0.8*X3 - X1| <= 300
int: c5_rhs = 50;    % X4 >= X2 + 50

% The statement mentions bounds but does not provide numeric values.
% Keep variables bounded for solver robustness; adjust if true bounds are known.
int: X_min = 0;
int: X_max = 100000;


% Variables
% Resource allocations (whole numbers) for projects [X1,X2,X3,X4]
array[PROJECTS] of var int: x;

% Total cost to minimize
var int: total_cost;


% Constraints
%----------------------------
% Domain / integrality bounds
%----------------------------
constraint
  forall(p in PROJECTS) (
    x[p] >= X_min /\ x[p] <= X_max
  );

%-----------------------------------------
% Cost aggregation (defines total_cost var)
%-----------------------------------------
constraint
  total_cost = sum(p in PROJECTS)(cost[p] * x[p]);

%-------------------------------------------------------
% C1: |0.5*X2 - X1| <= 100  (avoid floats via scaling)
%     Equivalent: |X2 - 2*X1| <= 200
%-------------------------------------------------------
constraint
  abs(x[2] - 2 * x[1]) <= 2 * c1_rhs;

%-------------------------------------------------------
% C2: X1 >= 200 + 0.7*X3  (avoid floats via scaling)
%     Equivalent: 10*X1 >= 10*200 + 7*X3
%-------------------------------------------------------
constraint
  10 * x[1] >= 10 * c2_rhs + 7 * x[3];

%-------------------------------------------------------
% C3: |X4 - 0.6*X2| <= 150  (avoid floats via scaling)
%     Equivalent: |10*X4 - 6*X2| <= 1500
%-------------------------------------------------------
constraint
  abs(10 * x[4] - 6 * x[2]) <= 10 * c3_rhs;

%-------------------------------------------------------
% C4: |0.8*X3 - X1| <= 300  (avoid floats via scaling)
%     Equivalent: |8*X3 - 10*X1| <= 3000
%-------------------------------------------------------
constraint
  abs(8 * x[3] - 10 * x[1]) <= 10 * c4_rhs;

%-------------------------------------------------------
% C5: X4 >= X2 + 50
%-------------------------------------------------------
constraint
  x[4] >= x[2] + c5_rhs;


% Objective
solve minimize total_cost;