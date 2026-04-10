% Parameters
int: num_tasks = 3;
set of int: TASKS = 1..num_tasks;
set of int: METHODS = 1..2; % 1=A, 2=B

int: req_eff_hours_task1 = 8400;
int: req_eff_hours_task2 = 10800;
int: req_eff_hours_task3 = 18000;

int: wage_skilled = 100;
int: wage_labor = 80;

int: eff_hours_skilled = 42;
int: eff_hours_labor = 36;

int: max_skilled = 400;
int: max_labor = 800;

int: fixed_cost_t1_methodB = 500;

% Variables
array[TASKS, METHODS] of var 0..1: use; % use[t,m]=1 iff method m chosen for task t

var 0..max_skilled: S; % total skilled hired
var 0..max_labor: L;   % total labor hired

% Hours assigned per task and worker type (effective hours)
array[TASKS] of var 0..(max_skilled * eff_hours_skilled): hs; % skilled effective hours assigned
array[TASKS] of var 0..(max_labor * eff_hours_labor): hl;     % labor effective hours assigned

% Constraints
constraint
  forall(t in TASKS) (
    sum(m in METHODS)(use[t,m]) = 1
  );

% Task feasibility and composition constraints
% Task 1:
% - Method A: skilled only
% - Method B: 1 skilled + 2 labor per "team-week" => hs/42 = x, hl/36 = 2x => hl = (2*36/42) hs = (12/7) hs => 7*hl = 12*hs
constraint
  hs[1] + hl[1] = req_eff_hours_task1;

constraint
  (use[1,1] = 1 -> (hl[1] = 0)) /\
  (use[1,2] = 1 -> (7*hl[1] = 12*hs[1] /\ hs[1] > 0));

% Task 2:
% - Method A: skilled only
% - Method B: labor only
constraint
  hs[2] + hl[2] = req_eff_hours_task2;

constraint
  (use[2,1] = 1 -> (hl[2] = 0)) /\
  (use[2,2] = 1 -> (hs[2] = 0));

% Task 3:
% - Method A: groups of five laborers => skilled 0, labor only
% - Method B: 1 skilled + 3 labor => 3 labor-weeks per skilled-week => hl = (3*36/42) hs = (18/7) hs => 7*hl = 18*hs
constraint
  hs[3] + hl[3] = req_eff_hours_task3;

constraint
  (use[3,1] = 1 -> (hs[3] = 0)) /\
  (use[3,2] = 1 -> (7*hl[3] = 18*hs[3] /\ hs[3] > 0));

% Total hired worker capacity in effective hours
constraint sum(t in TASKS)(hs[t]) <= S * eff_hours_skilled;
constraint sum(t in TASKS)(hl[t]) <= L * eff_hours_labor;

% Exclusion rule: if Task1 uses Method B then Task3 cannot use Method A
constraint use[1,2] + use[3,1] <= 1;

% Minimum assignment: if Task3 uses Method B then at least 20 skilled assigned to it
% hs[3] = 42 * (#skilled-weeks for task3), so hs[3] >= 42*20 when method B is used
constraint hs[3] >= (20 * eff_hours_skilled) * use[3,2];

% Hiring policy: skilled hired cannot exceed 60% of labor hired
% S <= 0.6 L  <=> 10*S <= 6*L
constraint 10 * S <= 6 * L;

% Objective
var int: total_cost =
  wage_skilled * S
+ wage_labor * L
+ fixed_cost_t1_methodB * use[1,2];

solve minimize total_cost;