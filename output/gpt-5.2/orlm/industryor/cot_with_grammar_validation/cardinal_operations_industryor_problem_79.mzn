% Parameters
int: nTasks = 3;
set of int: TASKS = 1..nTasks;
set of int: METHODS = 1..2; % 1=A, 2=B

int: reqHours1 = 8400;
int: reqHours2 = 10800;
int: reqHours3 = 18000;

int: wageS = 100;
int: wageL = 80;

int: effS = 42;
int: effL = 36;

int: maxS = 400;
int: maxL = 800;

int: fixedCost_T1_MethodB = 500;

% Variables
array[TASKS, METHODS] of var 0..1: x;  % x[t,m]=1 if method m chosen for task t

var 0..maxS: HS; % skilled workers hired
var 0..maxL: HL; % laborers hired

% Task-wise assignments (by workers available to that task through chosen method)
var 0..maxS: s1; var 0..maxL: l1;
var 0..maxS: s2; var 0..maxL: l2;
var 0..maxS: s3; var 0..maxL: l3;

var 0..maxS: teams1; % for Task1 MethodB: teams of (1S,2L)
var 0..maxL: teams3A; % for Task3 MethodA: groups of 5L (counted as teams)
var 0..maxS: teams3B; % for Task3 MethodB: teams of (1S,3L)

var int: totalCost;

% Constraints
constraint forall(t in TASKS) (sum(m in METHODS)(x[t,m]) = 1);

% Link Task 1 staffing to method choice
constraint s1 <= maxS * x[1,1] + maxS * x[1,2];
constraint l1 <= maxL * x[1,1] + maxL * x[1,2];

% Method A for Task1: skilled only
constraint l1 = 0 * x[1,1] + l1 * x[1,2]; % forces l1=0 when MethodA chosen
constraint teams1 <= maxS * x[1,2];
constraint s1 = (s1) * x[1,1] + teams1; % if MethodB, s1=teams1; if MethodA, s1 free (bounded below)
constraint l1 = 2 * teams1;

% Ensure correct for MethodA: use all skilled assigned as s1 and no teams1
constraint teams1 = teams1 * x[1,2];
constraint s1 <= maxS * x[1,1] + maxS * x[1,2];
constraint s1 >= teams1; % already implied, but keeps consistent

% Task 1 hours requirement
constraint effS * s1 + effL * l1 >= reqHours1;

% Link Task 2 staffing to method choice
constraint s2 <= maxS * x[2,1];
constraint l2 <= maxL * x[2,2];
constraint (x[2,1] = 1) -> (l2 = 0);
constraint (x[2,2] = 1) -> (s2 = 0);
constraint effS * s2 + effL * l2 >= reqHours2;

% Link Task 3 staffing to method choice
constraint teams3A <= maxL * x[3,1];
constraint teams3B <= maxS * x[3,2];

constraint (x[3,1] = 1) -> (teams3B = 0 /\ s3 = 0 /\ l3 = 5 * teams3A);
constraint (x[3,2] = 1) -> (teams3A = 0 /\ s3 = teams3B /\ l3 = 3 * teams3B);

constraint s3 <= maxS;
constraint l3 <= maxL;

% Task 3 hours requirement
constraint effS * s3 + effL * l3 >= reqHours3;

% Total hired must cover total assigned across tasks
constraint s1 + s2 + s3 <= HS;
constraint l1 + l2 + l3 <= HL;

% Exclusion Rule: if Task1 uses MethodB, Task3 cannot use MethodA
constraint x[1,2] + x[3,1] <= 1;

% Minimum Assignment: if Task3 uses MethodB, at least 20 skilled assigned to it
constraint (x[3,2] = 1) -> (s3 >= 20);

% Hiring policy: skilled <= 60% of laborers  => 5*HS <= 3*HL
constraint 5 * HS <= 3 * HL;

% Objective
constraint totalCost = wageS * HS + wageL * HL + fixedCost_T1_MethodB * x[1,2];
solve minimize totalCost;