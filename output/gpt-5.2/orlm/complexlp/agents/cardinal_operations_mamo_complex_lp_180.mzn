% Parameters
int: n = 10; % number of flights (must land in order 1..n)

array[1..n] of int: a = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90];       % earliest landing times
array[1..n] of int: b = [60, 70, 80, 90, 100, 110, 120, 130, 140, 150]; % latest landing times

int: minTime = min(a); % global earliest time bound
int: maxTime = max(b); % global latest time bound

% Variables
array[1..n] of var int: t;                 % landing time of flight j
var 0..(maxTime - minTime): sep;           % minimum separation time between consecutive landings

% Constraints
% Landing time windows for each flight (must land within [a[j], b[j]])
constraint
  forall(j in 1..n) (
    a[j] <= t[j] /\ t[j] <= b[j]
  );

% Enforce landing order and minimum separation between consecutive flights
constraint
  forall(j in 1..n-1) (
    t[j+1] - t[j] >= sep
  );

% Objective
solve maximize sep;

output [
  "max_min_separation = ", show(sep), "\n",
  "landing_times = ", show(t), "\n"
];