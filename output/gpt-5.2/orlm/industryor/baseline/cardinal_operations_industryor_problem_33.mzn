% Container loading with minimum number of containers
% All data embedded

int: nTypes = 5;
set of int: T = 1..nTypes;

int: A = 1; int: B = 2; int: C = 3; int: D = 4; int: E = 5;

array[T] of string: name = ["A","B","C","D","E"];

array[T] of int: qty = [120, 90, 300, 90, 120];          % units available / must ship
array[T] of int: w100 = [50, 100, 40, 60, 65];           % weight * 100 (tons): 0.5,1,0.4,0.6,0.65

int: cap100 = 60 * 100;                                  % 60 tons
int: minload100 = 18 * 100;                              % 18 tons

% Upper bound on containers: at most total units (always feasible bound)
int: N = sum(t in T)(qty[t]);

set of int: K = 1..N;

% Decision variables: x[k,t] units of type t in container k
array[K, T] of var 0..max(qty): x;

% Whether container k is used
array[K] of var bool: use;

% Total weight per container (scaled by 100)
array[K] of var 0..cap100: load100;

constraint
  forall(k in K)(
    load100[k] = sum(t in T)(w100[t] * x[k,t])
  );

% Ship all goods exactly
constraint
  forall(t in T)(
    sum(k in K)(x[k,t]) = qty[t]
  );

% Link use[k] to having any load; and enforce min/max load if used
constraint
  forall(k in K)(
    load100[k] <= cap100 * bool2int(use[k]) /\
    load100[k] >= minload100 * bool2int(use[k])
  );

% Packaging requirement: if any A loaded then at least 1 unit of C loaded
% (C can be loaded without A)
constraint
  forall(k in K)(
    x[k,A] <= qty[A] * x[k,C]   % if x[k,C]=0 => x[k,A]=0; if x[k,C]>=1 => no extra restriction
  );

% Demand limitation for D: each used container must load at least 12 units of D
constraint
  forall(k in K)(
    x[k,D] >= 12 * bool2int(use[k])
  );

% Symmetry breaking: use earlier containers first
constraint
  forall(k in 1..N-1)(
    bool2int(use[k]) >= bool2int(use[k+1])
  );

var int: numContainers = sum(k in K)(bool2int(use[k]));

solve minimize numContainers;

output [
  "Minimum containers used: ", show(numContainers), "\n",
  "Container details (only used):\n"
] ++
[
  if fix(use[k]) = 1 then
    "k=" ++ show(k) ++
    " load=" ++ show(fix(load100[k]) / 100.0) ++ " tons" ++
    " | A=" ++ show(fix(x[k,A])) ++
    " B=" ++ show(fix(x[k,B])) ++
    " C=" ++ show(fix(x[k,C])) ++
    " D=" ++ show(fix(x[k,D])) ++
    " E=" ++ show(fix(x[k,E])) ++ "\n"
  else
    ""
  endif
  | k in K
];