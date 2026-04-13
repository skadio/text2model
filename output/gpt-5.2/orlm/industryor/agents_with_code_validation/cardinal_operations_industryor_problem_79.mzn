% Parameters
int: nTasks = 3;                         % number of tasks
set of int: TASKS = 1..nTasks;
set of int: METHODS = 1..2;              % 1 = Method A, 2 = Method B

int: maxSkilled = 400;                   % upper bound on skilled workers hired
int: maxLabor = 800;                     % upper bound on laborers hired

int: wageSkilled = 100;                  % yuan per skilled worker per week
int: wageLabor = 80;                     % yuan per laborer per week
int: hoursSkilled = 42;                  % effective hours/week per skilled worker
int: hoursLabor = 36;                    % effective hours/week per laborer

array[TASKS] of int: reqHours = [8400, 10800, 18000];   % required effective hours per task

% Fixed setup cost (only applies to Task 1, Method B)
array[TASKS, METHODS] of int: fixedCost =
  [| 0, 500
   | 0,   0
   | 0,   0 |];

% Worker composition per "team" for each (task, method)
% hours produced by one team = skilledPerTeam*hoursSkilled + laborPerTeam*hoursLabor
array[TASKS, METHODS] of int: skilledPerTeam =
  [| 1, 1        % Task 1: A=1 skilled, B=1 skilled + 2 labor
   | 1, 0        % Task 2: A=1 skilled, B=1 labor
   | 0, 1 |];    % Task 3: A=5 labor,   B=1 skilled + 3 labor

array[TASKS, METHODS] of int: laborPerTeam =
  [| 0, 2
   | 0, 1
   | 5, 3 |];

int: minSkilledTask3_ifB = 20;           % minimum skilled assigned to Task 3 if Method B chosen


% Variables
array[TASKS, METHODS] of var bool: use;  % use[t,m] = true if method m is chosen for task t

% Number of teams/groups used for each (task, method); only one method per task will be active
int: maxTeams = 500;                     % safe upper bound for all tasks/methods
array[TASKS, METHODS] of var 0..maxTeams: teams;

% Total hired workers of each type
var 0..maxSkilled: skilledHired;         % total skilled workers hired
var 0..maxLabor: laborHired;             % total laborers hired

% Per-task workers (implied by chosen method and teams)
array[TASKS] of var 0..maxSkilled: skilledAssigned;
array[TASKS] of var 0..maxLabor: laborAssigned;

% Total weekly cost (wages + fixed costs)
var int: totalCost;


% Constraints

%--- Method selection: exactly one method per task
constraint
  forall(t in TASKS) (
    sum(m in METHODS)(bool2int(use[t,m])) = 1
  );

%--- Link teams to chosen method (teams positive only if method used)
constraint
  forall(t in TASKS, m in METHODS) (
    teams[t,m] <= maxTeams * bool2int(use[t,m])
  );

%--- Required effective hours must be met for each task by the chosen method
constraint
  forall(t in TASKS) (
    sum(m in METHODS)(
      teams[t,m] * (skilledPerTeam[t,m]*hoursSkilled + laborPerTeam[t,m]*hoursLabor)
    ) >= reqHours[t]
  );

%--- Define per-task assigned workers from the active method and number of teams
constraint
  forall(t in TASKS) (
    skilledAssigned[t] = sum(m in METHODS)(teams[t,m] * skilledPerTeam[t,m])
  );

constraint
  forall(t in TASKS) (
    laborAssigned[t] = sum(m in METHODS)(teams[t,m] * laborPerTeam[t,m])
  );

%--- Total hired workers must cover assignments across tasks
constraint skilledHired = sum(t in TASKS)(skilledAssigned[t]);
constraint laborHired   = sum(t in TASKS)(laborAssigned[t]);

%--- Worker availability limits (redundant with variable domains, kept for clarity)
constraint skilledHired <= maxSkilled;
constraint laborHired <= maxLabor;

%--- Exclusion rule: If Task 1 uses Method B, then Task 3 cannot use Method A
constraint
  bool2int(use[1,2]) + bool2int(use[3,1]) <= 1;

%--- Minimum skilled assignment: if Task 3 uses Method B, assign at least 20 skilled workers to it
constraint
  skilledAssigned[3] >= minSkilledTask3_ifB * bool2int(use[3,2]);

%--- Hiring policy: skilled hires cannot exceed 60% of labor hires  (5*skilled <= 3*labor)
constraint
  5 * skilledHired <= 3 * laborHired;

%--- Total weekly cost definition (wages + applicable fixed setup costs)
constraint
  totalCost =
    wageSkilled * skilledHired
  + wageLabor * laborHired
  + sum(t in TASKS, m in METHODS)(fixedCost[t,m] * bool2int(use[t,m]));


% Objective
solve minimize totalCost;