% Assignment problem: choose 4 of 5 workers and assign them to tasks A-D (one per task)
% Minimize total working hours.

enum WORKER = {I, II, III, IV, V};
enum TASK = {A, B, C, D};

array[WORKER, TASK] of int: hours =
  array2d(WORKER, TASK,
    [ 9, 4, 3, 7,   % I
      4, 6, 5, 6,   % II
      5, 4, 7, 5,   % III
      7, 5, 2, 3,   % IV
      10, 6, 7, 4   % V
    ]);

% x[w,t] = 1 if worker w is assigned to task t
array[WORKER, TASK] of var 0..1: x;

% Each task assigned to exactly one worker
constraint forall(t in TASK) (
  sum(w in WORKER)(x[w,t]) = 1
);

% Each worker assigned to at most one task (so exactly 4 workers used overall)
constraint forall(w in WORKER) (
  sum(t in TASK)(x[w,t]) <= 1
);

var int: total_hours = sum(w in WORKER, t in TASK)(hours[w,t] * x[w,t]);

solve minimize total_hours;

output [
  "Total hours = ", show(total_hours), "\n",
  "Assignments:\n"
] ++
[
  show(t) ++ " <- " ++ show(w) ++ " (" ++ show(hours[w,t]) ++ ")\n"
  | t in TASK, w in WORKER where fix(x[w,t]) = 1
];