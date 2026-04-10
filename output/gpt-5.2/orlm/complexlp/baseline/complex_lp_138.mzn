% Maximum flow from source (0) to sink (5) with embedded data

int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

array[N, N] of int: cap =
[
% to:  0  1  2  3  4  5
      [0,14,15,13, 0, 4], % from 0
      [10,0, 7,18, 9, 5], % from 1
      [11,0, 0, 7,13, 6], % from 2
      [ 7,11,18, 0,17, 2], % from 3
      [19, 8,15,15, 0, 5], % from 4
      [10,19,17, 2, 3, 0]  % from 5
];

array[N, N] of var 0..max(cap): f;

% Capacity constraints and no self-flow
constraint forall(i,j in N) (
  f[i,j] <= cap[i,j] /\
  (if i = j then f[i,j] = 0 else true endif)
);

% Flow conservation at intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(j in N)(f[j,k]) = sum(j in N)(f[k,j])
);

% Total flow value (out of source equals into sink)
var 0..sum(j in N)(cap[s,j]): F;
constraint F = sum(j in N)(f[s,j]) - sum(j in N)(f[j,s]);
constraint F = sum(i in N)(f[i,t]) - sum(i in N)(f[t,i]);

solve maximize F;

output [
  "Max trucks per hour from City ", show(s), " to City ", show(t), ": ", show(F), "\n",
  "Flow matrix f[i,j]:\n"
] ++
[
  (if i=0 then "" else "") ++
  "from " ++ show(i) ++ ": " ++
  concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in N ]) ++ "\n"
  | i in N
];