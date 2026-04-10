% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
%    0      1      2      3      4      5      6      7
[|  0, 18000,  5000,  6000,  8000, 10000, 16000,     0 |  % from 0
 |18000,     0,  1000, 15000, 20000, 13000,  1000,  2000 |  % from 1
 |18000, 16000,     0, 19000, 15000,  4000,  9000, 10000 |  % from 2
 |20000,  2000, 18000,     0, 19000, 17000, 15000, 19000 |  % from 3
 |14000, 13000, 14000,  1000,     0,  8000, 16000, 20000 |  % from 4
 |    0, 17000, 18000, 10000, 17000,     0, 16000,  6000 |  % from 5
 | 5000, 14000, 19000,  6000,     0, 19000,     0, 12000 |  % from 6
 | 7000, 16000, 17000, 13000,  6000,  9000,  5000,     0 |  % from 7
|];

int: maxCap = 20000;

% Variables
array[V, V] of var 0..maxCap: f;     % flow on each directed arc (thousands/hour)
var 0..(N*maxCap): F;                % total flow value (thousands/hour)

% Constraints
% Capacity constraints (and force 0 flow where there is no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective flow value as net outflow from source (equivalently net inflow to sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Objective
solve maximize F;