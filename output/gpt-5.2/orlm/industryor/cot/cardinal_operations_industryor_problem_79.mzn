% Parameters (with values embedded)
int: nTasks = 3;

int: maxSkilled = 400;
int: maxLabor = 800;

int: wageSkilled = 100;
int: wageLabor  = 80;

int: hoursPerWeekSkilled = 42;
int: hoursPerWeekLabor  = 36;

int: req1 = 8400;
int: req2 = 10800;
int: req3 = 18000;

int: fixedCostTask1_MethodB = 500;

% Variables
array[1..nTasks] of var bool: useA;  % method A chosen for each task
array[1..nTasks] of var bool: useB;  % method B chosen for each task

var 0..maxSkilled: S;  % total skilled hired
var 0..maxLabor:  L;   % total labor hired

% Effective hours produced per week per task by chosen method (continuous allowed)
var 0..1000000: h1;  % task 1 effective hours/week produced
var 0..1000000: h2;  % task 2 effective hours/week produced
var 0..1000000: h3;  % task 3 effective hours/week produced

% Implied worker demand by task/method (as real-valued; can represent fractional teams)
var 0..1000000: S1;
var 0..1000000: L1;
var 0..1000000: S2;
var 0..1000000: L2;
var 0..1000000: S3;
var 0..1000000: L3;

% Constraints
% Exactly one method per task
constraint forall(t in 1..nTasks) (useA[t] + useB[t] = 1);

% Exclusion Rule: if Task1 uses B then Task3 cannot use A
constraint useB[1] -> not useA[3];

% Minimum Assignment: if Task3 uses B then at least 20 skilled assigned to it
constraint useB[3] -> (S3 >= 20);

% Hiring policy: skilled <= 60% of labor  =>  10*S <= 6*L
constraint 10 * S <= 6 * L;

% Define effective-hour production by method for each task (weekly)
% Task 1:
%  - A: skilled only => 42 hours per skilled
%  - B: (1 skilled + 2 labor) teams => 42+2*36 = 114 hours per team
constraint h1 = useA[1] * (hoursPerWeekSkilled * S1) + useB[1] * (114.0 * (S1)); 
% For method B on task1: S1 is number of teams (also skilled assigned); labor is 2 per team
constraint L1 = useA[1] * 0.0 + useB[1] * (2.0 * S1);

% Task 2:
%  - A: skilled only
%  - B: labor only
constraint h2 = useA[2] * (hoursPerWeekSkilled * S2) + useB[2] * (hoursPerWeekLabor * L2);
constraint L2 >= 0.0;
constraint S2 >= 0.0;
constraint useA[2] -> (L2 = 0.0);
constraint useB[2] -> (S2 = 0.0);

% Task 3:
%  - A: groups of five laborers => 5*36 = 180 hours per group, using L3 laborers
%  - B: (1 skilled + 3 labor) teams => 42+3*36 = 150 hours per team
constraint h3 = useA[3] * (hoursPerWeekLabor * L3) + useB[3] * (150.0 * S3);
% For method A on task3: skilled is 0
constraint useA[3] -> (S3 = 0.0);
% For method B on task3: labor is 3 per team (S3 teams)
constraint useB[3] -> (L3 = 3.0 * S3);
% For method A on task3: laborers must be multiple of 5 (groups of five laborers)
% (If needed as integrality, keep workers integer; here enforce divisibility when A chosen.)
constraint useA[3] -> (L3 mod 5 = 0);

% Meet required effective hours (weekly) for each task
constraint h1 >= req1;
constraint h2 >= req2;
constraint h3 >= req3;

% Totals hired cover per-task assignments
constraint S = S1 + S2 + S3;
constraint L = L1 + L2 + L3;

% Ensure nonnegativity (already bounded) and integrality of worker counts
constraint S1 >= 0 /\ L1 >= 0 /\ S2 >= 0 /\ L2 >= 0 /\ S3 >= 0 /\ L3 >= 0;

% Objective
var 0..100000000: totalCost;
constraint totalCost =
  wageSkilled * S + wageLabor * L
  + fixedCostTask1_MethodB * bool2int(useB[1]);

solve minimize totalCost;