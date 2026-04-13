% Parameters
int: nWorkers = 5;                      % Number of workers (I..V)
int: nTasks   = 4;                      % Number of tasks (A..D)

set of int: Workers = 1..nWorkers;      % Worker indices
set of int: Tasks   = 1..nTasks;        % Task indices

array[Workers, Tasks] of int: hours =   % hours[w,t] = time for worker w to do task t
  [|  9, 4, 3, 7   % Worker I:   A,B,C,D
   |  4, 6, 5, 6   % Worker II
   |  5, 4, 7, 5   % Worker III
   |  7, 5, 2, 3   % Worker IV
   | 10, 6, 7, 4   % Worker V
  |];

% Variables
array[Workers, Tasks] of var 0..1: assign;   % assign[w,t]=1 if worker w is assigned to task t
array[Workers] of var 0..1: used;            % used[w]=1 if worker w is selected (does some task)
var 0..sum(w in Workers, t in Tasks)(hours[w,t]): totalHours;  % total working hours

% Constraints
% Link "used" to whether a worker is assigned to any task
constraint forall(w in Workers) (
  used[w] = bool2int(exists(t in Tasks)(assign[w,t] = 1))
);

% Each task must be assigned to exactly one worker
constraint forall(t in Tasks) (
  sum(w in Workers)(assign[w,t]) = 1
);

% Each worker can do at most one task (since 4 out of 5 workers are chosen)
constraint forall(w in Workers) (
  sum(t in Tasks)(assign[w,t]) <= 1
);

% Exactly 4 workers are used (one worker remains unassigned)
constraint sum(w in Workers)(used[w]) = nTasks;

% Total hours computation from assignments
constraint totalHours = sum(w in Workers, t in Tasks)(hours[w,t] * assign[w,t]);

% Objective
solve minimize totalHours;