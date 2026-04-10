include "globals.mzn";

% -----------------------------
% Data (embedded from statement)
% -----------------------------
int: maxS = 400;                 % skilled workers limit
int: maxL = 800;                 % laborers limit

int: wageS = 100;                % yuan/week
int: wageL = 80;                 % yuan/week

int: effS = 42;                  % effective hours/week per skilled
int: effL = 36;                  % effective hours/week per laborer

int: req1 = 8400;                % required effective hours for task 1
int: req2 = 10800;               % task 2
int: req3 = 18000;               % task 3

int: setup1B = 500;              % fixed weekly setup cost if Task1 uses method B

% -----------------------------
% Decision variables
% -----------------------------
% Method choice: 1 = A, 2 = B
var 1..2: m1;
var 1..2: m2;
var 1..2: m3;

% Workers assigned to each task
var 0..maxS: s1;
var 0..maxS: s2;
var 0..maxS: s3;

var 0..maxL: l1;
var 0..maxL: l2;
var 0..maxL: l3;

% Totals hired (must cover assignments)
var 0..maxS: S;
var 0..maxL: L;

% -----------------------------
% Linking totals to assignments
% -----------------------------
constraint S = s1 + s2 + s3;
constraint L = l1 + l2 + l3;

constraint S <= maxS;
constraint L <= maxL;

% Hiring policy: skilled cannot exceed 60% of laborers
% S <= 0.6 L  <=>  10S <= 6L
constraint 10 * S <= 6 * L;

% -----------------------------
% Task method constraints & hour requirements
% -----------------------------

% Task 1:
% A: skilled alone, hours: 42*s1 >= 8400, l1 = 0
% B: teams of (1 skilled + 2 laborers), so l1 = 2*s1, and hours: 42*s1 + 36*l1 >= 8400
constraint
  if m1 = 1 then
    l1 = 0 /\ effS * s1 >= req1
  else
    l1 = 2 * s1 /\ (effS * s1 + effL * l1 >= req1)
  endif;

% Task 2:
% A: skilled alone, l2=0, 42*s2 >= 10800
% B: laborers alone, s2=0, 36*l2 >= 10800
constraint
  if m2 = 1 then
    l2 = 0 /\ effS * s2 >= req2
  else
    s2 = 0 /\ effL * l2 >= req2
  endif;

% Task 3:
% A: groups of 5 laborers => skilled none, hours: 36*l3 >= 18000, s3=0
% B: teams of (1 skilled + 3 laborers) => l3 = 3*s3, hours: 42*s3 + 36*l3 >= 18000
constraint
  if m3 = 1 then
    s3 = 0 /\ effL * l3 >= req3
  else
    l3 = 3 * s3 /\ (effS * s3 + effL * l3 >= req3)
  endif;

% Exclusion rule: if Task1 uses B then Task3 cannot use A
constraint (m1 = 2) -> (m3 = 2);

% Minimum assignment: if Task3 uses B then at least 20 skilled assigned
constraint (m3 = 2) -> (s3 >= 20);

% -----------------------------
% Objective: minimize weekly cost
% -----------------------------
var int: fixedCost = if m1 = 2 then setup1B else 0 endif;
var int: wageCost = wageS * S + wageL * L;
var int: totalCost = wageCost + fixedCost;

solve minimize totalCost;

% -----------------------------
% Output
% -----------------------------
output [
  "Methods (1=A,2=B): m1=", show(m1), " m2=", show(m2), " m3=", show(m3), "\n",
  "Assignments:\n",
  "  Task1: skilled=", show(s1), " labor=", show(l1), "\n",
  "  Task2: skilled=", show(s2), " labor=", show(l2), "\n",
  "  Task3: skilled=", show(s3), " labor=", show(l3), "\n",
  "Totals hired: skilled=", show(S), " labor=", show(L), "\n",
  "Costs: wages=", show(wageCost), " fixed=", show(fixedCost), " total=", show(totalCost), "\n"
];