include "globals.mzn";

%======================
% Data (embedded)
%======================
int: K = 5;
set of int: T = 1..K;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[T] of int: qty = [120, 90, 300, 90, 120];

% Scale tons by 100 to use integers:
% A=0.5 -> 50, B=1.0 -> 100, C=0.4 -> 40, D=0.6 -> 60, E=0.65 -> 65
array[T] of int: w100 = [50, 100, 40, 60, 65];

int: cap100 = 60 * 100;        % 60 tons
int: minload100 = 18 * 100;    % 18 tons
int: minD = 12;

% Tight upper bound on number of containers:
% D must be at least 12 per used container and total D is 90 => at most 7.5 -> 7 containers
int: maxContainers = qty[D] div minD; % = 7

%======================
% Variables
%======================
array[1..maxContainers, T] of var 0..max(qty): x;
array[1..maxContainers] of var bool: use;

% Helper: load in each container (scaled weight)
array[1..maxContainers] of var 0..cap100: load100 =
  [sum(t in T)(x[c,t] * w100[t]) | c in 1..maxContainers];

%======================
% Constraints
%======================
% Meet all demand exactly
constraint forall(t in T)(
  sum(c in 1..maxContainers)(x[c,t]) = qty[t]
);

% Capacity
constraint forall(c in 1..maxContainers)(
  load100[c] <= cap100
);

% Minimum load if used; if not used then no load
constraint forall(c in 1..maxContainers)(
  load100[c] >= minload100 * bool2int(use[c])
);

% Link use to any positive assignment
constraint forall(c in 1..maxContainers, t in T)(
  x[c,t] <= qty[t] * bool2int(use[c])
);

% Packaging requirement: if any A in a container then at least 1 unit of C in same container
% Implemented as xA <= qty[A] * (xC >= 1)
constraint forall(c in 1..maxContainers)(
  x[c,A] <= qty[A] * bool2int(x[c,C] >= 1)
);

% Each used container must load at least 12 units of D
constraint forall(c in 1..maxContainers)(
  x[c,D] >= minD * bool2int(use[c])
);

% Symmetry breaking: use containers in order
constraint forall(c in 1..maxContainers-1)(
  bool2int(use[c]) >= bool2int(use[c+1])
);

%======================
% Objective (as requested: maximization)
% Maximize total loaded weight (will be constant if all demand must be shipped)
%======================
solve maximize sum(c in 1..maxContainers)(load100[c]);

% Optional output
output [
  "containers_used = ", show(sum(c in 1..maxContainers)(bool2int(use[c]))), "\n",
  "total_load100 = ", show(sum(c in 1..maxContainers)(load100[c])), "\n",
  "x =\n",
  concat([ "c" ++ show(c) ++ " use=" ++ show(use[c]) ++
           " load=" ++ show(load100[c]) ++ " : " ++
           "A=" ++ show(x[c,A]) ++ " " ++
           "B=" ++ show(x[c,B]) ++ " " ++
           "C=" ++ show(x[c,C]) ++ " " ++
           "D=" ++ show(x[c,D]) ++ " " ++
           "E=" ++ show(x[c,E]) ++ "\n"
         | c in 1..maxContainers ])
];