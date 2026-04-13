% MiniZinc model: Workforce planning with method selection for 3 tasks
% All data embedded.

include "globals.mzn";

%-----------------------------
% Data
%-----------------------------
int: maxSkilled = 400;
int: maxLabor   = 800;

int: wageSkilled = 100;   % yuan/week
int: wageLabor   = 80;    % yuan/week

int: hrsSkilled = 42;     % effective hours per worker-week
int: hrsLabor   = 36;     % effective hours per worker-week

int: req1 = 8400;
int: req2 = 10800;
int: req3 = 18000;

int: setupCostTask1_MethodB = 500;

%-----------------------------
% Decision variables
%-----------------------------
% Method choice: true = Method B, false = Method A
var bool: t1_B;
var bool: t2_B;
var bool: t3_B;

% Workers hired (available pool)
var 0..maxSkilled: S;   % skilled workers hired
var 0..maxLabor:   L;   % laborers hired

% Workers assigned to each task (must be <= hired)
var 0..maxSkilled: S1;
var 0..maxSkilled: S2;
var 0..maxSkilled: S3;

var 0..maxLabor:   L1;
var 0..maxLabor:   L2;
var 0..maxLabor:   L3;

% Team counts when a method requires fixed composition
var 0..maxSkilled: x1;  % Task1 Method B teams: 1 skilled + 2 labor
var 0..maxLabor:   x3A; % Task3 Method A teams: 5 labor
var 0..maxSkilled: x3B; % Task3 Method B teams: 1 skilled + 3 labor

%-----------------------------
% Constraints
%-----------------------------

% Hiring policy: skilled <= 60% of labor  =>  5*S <= 3*L
constraint 5 * S <= 3 * L;

% Assignment cannot exceed hiring
constraint S1 + S2 + S3 <= S;
constraint L1 + L2 + L3 <= L;

%---------------- Task 1 ----------------
% Method A: skilled only, meet hours.
% Method B: x1 teams, each team uses 1 skilled and 2 labor, meet hours.
constraint
  if t1_B then
    S1 = x1 /\
    L1 = 2 * x1 /\
    hrsSkilled * S1 + hrsLabor * L1 >= req1
  else
    L1 = 0 /\
    hrsSkilled * S1 >= req1
  endif;

%---------------- Task 2 ----------------
% Method A: skilled only. Method B: labor only.
constraint
  if t2_B then
    S2 = 0 /\
    hrsLabor * L2 >= req2
  else
    L2 = 0 /\
    hrsSkilled * S2 >= req2
  endif;

%---------------- Task 3 ----------------
% Method A: teams of 5 labor
% Method B: teams of 1 skilled + 3 labor; minimum 20 skilled assigned if chosen
constraint
  if t3_B then
    S3 = x3B /\
    L3 = 3 * x3B /\
    hrsSkilled * S3 + hrsLabor * L3 >= req3 /\
    S3 >= 20
  else
    S3 = 0 /\
    L3 = 5 * x3A /\
    hrsLabor * L3 >= req3
  endif;

% Exclusion rule: If Task1 uses Method B then Task3 cannot use Method A
% i.e., t1_B => t3_B
constraint t1_B -> t3_B;

%-----------------------------
% Objective
%-----------------------------
var int: totalCost =
    wageSkilled * S + wageLabor * L
  + (if t1_B then setupCostTask1_MethodB else 0 endif);

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost (yuan/week): ", show(totalCost), "\n",
  "Methods chosen (A=false, B=true):\n",
  "  Task1 t1_B=", show(t1_B), "\n",
  "  Task2 t2_B=", show(t2_B), "\n",
  "  Task3 t3_B=", show(t3_B), "\n",
  "Hired: Skilled S=", show(S), ", Labor L=", show(L), "\n",
  "Assigned:\n",
  "  Task1: S1=", show(S1), ", L1=", show(L1), " (x1=", show(x1), ")\n",
  "  Task2: S2=", show(S2), ", L2=", show(L2), "\n",
  "  Task3: S3=", show(S3), ", L3=", show(L3),
  " (x3A=", show(x3A), ", x3B=", show(x3B), ")\n"
];