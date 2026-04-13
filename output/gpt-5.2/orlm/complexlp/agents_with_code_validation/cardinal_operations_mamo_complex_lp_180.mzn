% Parameters
int: n = 10;                                  % number of flights (fixed order 1..n)
set of int: FLIGHTS = 1..n;                   % flight index set

array[FLIGHTS] of int: a =                    % earliest landing time a[j]
  [0, 10, 20, 30, 40, 50, 60, 70, 80, 90];

array[FLIGHTS] of int: b =                    % latest landing time b[j]
  [60, 70, 80, 90, 100, 110, 120, 130, 140, 150];

int: minA = min(a);                           % global min earliest time (for bounds)
int: maxB = max(b);                           % global max latest time (for bounds)

% Variables
array[FLIGHTS] of var minA..maxB: t;          % landing time of flight j
var 0..(maxB - minA): s;                      % minimum separation time to maximize

% Constraints
%--- Time-window feasibility for each flight (landing must occur within [a[j], b[j]])
constraint
  forall(j in FLIGHTS) (
    a[j] <= t[j] /\ t[j] <= b[j]
  );

%--- Enforce fixed landing order with at least minimum separation s between consecutive flights
constraint
  forall(j in 1..n-1) (
    t[j+1] - t[j] >= s
  );

% Objective
solve maximize s;