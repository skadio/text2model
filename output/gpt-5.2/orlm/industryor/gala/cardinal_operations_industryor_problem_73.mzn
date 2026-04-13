include "globals.mzn";

% Project scheduling with precedence constraints and cost minimization.
% Data is embedded (no .dzn needed).

enum ACT = {A,B,C,D,E,F,G};
int: n = card(ACT);

array[ACT] of int: dur = [4,3,5,2,10,10,1]; % days

% Decision variables: start times (integer days) and makespan
int: UB = sum(a in ACT)(dur[a]);            % safe horizon upper bound
array[ACT] of var 0..UB: s;                 % start time of each activity
array[ACT] of var 0..UB: e;                 % end time of each activity
var 0..UB: T;                               % project completion time (makespan)

% Costs
int: work_cost_per_day = 1000;
int: machine_cost_per_day = 5000;

% End time definition
constraint forall(a in ACT)(
  e[a] = s[a] + dur[a]
);

% Precedence constraints:
% A -> G, D
constraint s[G] >= e[A];
constraint s[D] >= e[A];

% E, G -> F
constraint s[F] >= e[E];
constraint s[F] >= e[G];

% D, F -> C
constraint s[C] >= e[D];
constraint s[C] >= e[F];

% F -> B
constraint s[B] >= e[F];

% Makespan
constraint forall(a in ACT)(T >= e[a]);

% Machine rental: from start of A to end of B
var 0..UB: machine_days = e[B] - s[A];
constraint machine_days >= 0;

% Total cost:
% - Work cost is proportional to total activity duration (constant here)
% - Machine cost proportional to rental duration
int: total_work_days = sum(a in ACT)(dur[a]);
int: base_work_cost = work_cost_per_day * total_work_days;

var 0..intmax: total_cost =
  base_work_cost + machine_cost_per_day * machine_days;

solve minimize total_cost;

output [
  "Start times (days):\n",
  "A=", show(s[A]), "  B=", show(s[B]), "  C=", show(s[C]), "  D=", show(s[D]),
  "  E=", show(s[E]), "  F=", show(s[F]), "  G=", show(s[G]), "\n",
  "End times (days):\n",
  "A=", show(e[A]), "  B=", show(e[B]), "  C=", show(e[C]), "  D=", show(e[D]),
  "  E=", show(e[E]), "  F=", show(e[F]), "  G=", show(e[G]), "\n",
  "Makespan T=", show(T), "\n",
  "Machine rental days (end(B)-start(A))=", show(machine_days), "\n",
  "Base work cost=", show(base_work_cost), " EUR\n",
  "Total cost=", show(total_cost), " EUR\n"
];