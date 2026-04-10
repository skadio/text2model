% Nurse night-shift cyclic scheduling (7-day week)

% Parameters
int: Period;                    % number of consecutive working days (0..7)
array[1..7] of int: Demand;     % required nurses per day

% Sanity constraints on inputs
constraint 0 <= Period /\ Period <= 7;
constraint forall(d in 1..7)(Demand[d] >= 0);

% Upper bound on hires
int: UB = sum(d in 1..7)(Demand[d]);

% Variables
array[1..7] of var 0..UB: Start;   % Start[s] = nurses whose work-block starts on day s
var 0..UB: N;                      % total nurses hired

% Total nurses hired equals total starts (each nurse starts exactly once in the cycle)
constraint N = sum(s in 1..7)(Start[s]);

% Coverage constraints:
% A nurse starting on day s works Period consecutive days (cyclic over 7 days).
constraint
  forall(d in 1..7)(
    sum(s in 1..7)(
      Start[s] * bool2int(((d - s + 7) mod 7) < Period)
    ) >= Demand[d]
  );

% Objective
solve minimize N;

output [
  "N = ", show(N), "\n",
  "Start = ", show(Start), "\n"
];