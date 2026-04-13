% Parameters
int: total_budget = 5000;                 % Maximum total allocation across all departments
int: min_effectiveness = 2000;            % Minimum required effectiveness score
int: max_imbalance = 100;                % Maximum allowed imbalance in 2*X2 - (X1+X3)

float: eff_x1 = 0.5;                     % Effectiveness coefficient for X1 (not used directly; see scaled constraint)
float: eff_x2 = 0.4;                     % Effectiveness coefficient for X2 (not used directly; see scaled constraint)
float: eff_x3 = 0.6;                     % Effectiveness coefficient for X3 (not used directly; see scaled constraint)

int: cost_x1 = 50;                       % Cost per unit for X1
int: cost_x2 = 75;                       % Cost per unit for X2
int: cost_x3 = 60;                       % Cost per unit for X3

int: x1_min = 0;   int: x1_max = 3000;   % Bounds for X1 allocation
int: x2_min = 0;   int: x2_max = 2500;   % Bounds for X2 allocation
int: x3_min = 0;   int: x3_max = 1500;   % Bounds for X3 allocation


% Variables
var x1_min..x1_max: x1;                  % Allocation to department X1 (integer units)
var x2_min..x2_max: x2;                  % Allocation to department X2 (integer units)
var x3_min..x3_max: x3;                  % Allocation to department X3 (integer units)

var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost; % Total cost to minimize

% Auxiliary variable for rounding effectiveness constraint (avoid floats in constraints)
% Multiply effectiveness constraint by 10:
% 0.5*x1 + 0.4*x2 + 0.6*x3 >= 2000
% => 5*x1 + 4*x2 + 6*x3 >= 20000
var 0..(5*x1_max + 4*x2_max + 6*x3_max): effectiveness10;             % 10x effectiveness score

% Auxiliary variable for absolute imbalance
var 0..(2*x2_max + x1_max + x3_max): imbalance_abs;                   % |2*x2 - (x1+x3)|


% Constraints

%-------------------------------
% Total allocation (budget) limit
%-------------------------------
constraint
  x1 + x2 + x3 <= total_budget;

%--------------------------------------------
% Effectiveness requirement (scaled by 10x)
% 5*x1 + 4*x2 + 6*x3 >= 20000
%--------------------------------------------
constraint
  effectiveness10 = 5*x1 + 4*x2 + 6*x3;

constraint
  effectiveness10 >= 10 * min_effectiveness;

%------------------------------------------
% Imbalance constraint: |2*x2 - (x1 + x3)| <= max_imbalance
%------------------------------------------
constraint
  imbalance_abs = abs(2*x2 - (x1 + x3));

constraint
  imbalance_abs <= max_imbalance;

%-----------------------
% Total cost definition
%-----------------------
constraint
  total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;


% Objective
solve minimize total_cost;