% Parameters
int: n = 10; % number of flights (fixed landing order 1..n)

array[1..n] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128]; % earliest landing times a[j]
array[1..n] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151]; % latest landing times b[j]

int: minTime = min(a); % global earliest time (for bounds)
int: maxTime = max(b); % global latest time (for bounds)

% Variables
array[1..n] of var int: t;               % landing time of flight j
var 0..(maxTime - minTime): sep_min;     % minimum separation between consecutive landings (to maximize)

% Constraints

% Landing time windows: each flight must land within its allowed interval [a[j], b[j]]
constraint
  forall(j in 1..n) (
    t[j] >= a[j] /\ t[j] <= b[j]
  );

% Fixed landing order: landings must be non-decreasing in the given order 1..n
constraint
  forall(j in 1..n-1) (
    t[j] <= t[j+1]
  );

% Enforce minimum separation: each consecutive separation must be at least sep_min
constraint
  forall(j in 1..n-1) (
    t[j+1] - t[j] >= sep_min
  );

% Objective
solve maximize sep_min;