% Project scheduling with precedence constraints and cost minimization
% Data embedded directly as requested.

include "globals.mzn";

%-----------------------
% Data
%-----------------------
int: n = 7;
set of int: ACT = 1..n;

array[ACT] of string: name = ["A","B","C","D","E","F","G"];
array[ACT] of int: dur = [4, 3, 5, 2, 10, 10, 1];

% Indices
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

% Precedence arcs (i -> j means start(j) >= start(i) + dur(i))
int: m = 7;
array[1..m] of int: pred = [A, A, E, G, D, F, F];
array[1..m] of int: succ = [G, D, F, F, C, C, B];

% Costs
int: work_cost_per_day = 1000;      % Euros/day
int: machine_cost_per_day = 5000;   % Euros/day (from start of A to end of B)

% A safe upper bound on the horizon
int: H = sum(dur);

%-----------------------
% Decision variables
%-----------------------
array[ACT] of var 0..H: s;         % start time for each activity
array[ACT] of var 0..H: e;         % end time for each activity
var 0..H: makespan;                % project completion time (end of last activity)
var 0..H: machine_span;            % from start of A to end of B

%-----------------------
% Constraints
%-----------------------
constraint forall(i in ACT) (
  e[i] = s[i] + dur[i]
);

constraint forall(k in 1..m) (
  s[succ[k]] >= e[pred[k]]
);

% Makespan is at least every activity end
constraint forall(i in ACT) (
  makespan >= e[i]
);

% Machine rental span: from start(A) to end(B)
constraint machine_span = e[B] - s[A];

%-----------------------
% Objective
% Total cost = work cost + machine rental cost.
% Work cost: sum of activity durations * 1000 (constant).
% Minimization thus equivalent to minimizing machine_span, but we keep full linear expression.
%-----------------------
int: total_work_cost_const = work_cost_per_day * sum(i in ACT)(dur[i]);
var int: total_cost = total_work_cost_const + machine_cost_per_day * machine_span;

solve minimize total_cost;

%-----------------------
% Output
%-----------------------
output [
  "Schedule (start, end):\n"
] ++
[
  name[i] ++ ": (" ++ show(s[i]) ++ ", " ++ show(e[i]) ++ ")\n"
  | i in ACT
] ++
[
  "\nMakespan: " ++ show(makespan) ++ " days\n",
  "Machine span (start A to end B): " ++ show(machine_span) ++ " days\n",
  "Total work cost (constant): " ++ show(total_work_cost_const) ++ " EUR\n",
  "Total cost: " ++ show(total_cost) ++ " EUR\n"
];