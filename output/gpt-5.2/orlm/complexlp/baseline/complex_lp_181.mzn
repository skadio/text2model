% Air traffic landing times with ordered landings.
% Maximize the minimum separation between consecutive landings.

int: n = 10;
set of int: F = 1..n;

array[F] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128];
array[F] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151];

% Decision variables: landing times
array[F] of var int: t;
var int: s; % minimum separation to maximize

constraint forall(j in F) (
  t[j] >= a[j] /\ t[j] <= b[j]
);

% Landings must occur in order 1..n, with at least separation s
constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= s
);

% Tighten variable domains
constraint forall(j in F) (
  t[j] >= a[j] /\ t[j] <= b[j]
);

% Objective: maximize minimum separation
solve maximize s;

output [
  "max_min_separation = ", show(s), "\n",
  "landing_times = ", show(t), "\n"
];