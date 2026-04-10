% Parameters
int: n = 10; % number of flights (must land in order 1..n)

array[1..n] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128]; % earliest landing times
array[1..n] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151]; % latest landing times

int: minTime = min(a); % global earliest possible time (for bounding)
int: maxTime = max(b); % global latest possible time (for bounding)

% Variables
array[1..n] of var int: t;     % landing time of flight j
var 0..(maxTime - minTime): d; % minimum separation time between consecutive landings (to maximize)

% Constraints

% --- Landing times must be within their allowed windows ---
constraint
  forall(j in 1..n) (
    a[j] <= t[j] /\ t[j] <= b[j]
  );

% --- Enforce the given landing order (non-decreasing times) ---
constraint
  forall(j in 1..n-1) (
    t[j] <= t[j+1]
  );

% --- Minimum separation definition: each consecutive separation must be at least d ---
constraint
  forall(j in 1..n-1) (
    t[j+1] - t[j] >= d
  );

% Objective
solve maximize d;