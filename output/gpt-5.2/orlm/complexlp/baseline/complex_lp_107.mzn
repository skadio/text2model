% Max flow from Station 0 (source) to Station 6 (sink) with embedded data

int: n = 7;
set of int: N = 0..n-1;
int: s = 0;
int: t = 6;

array[N, N] of int: cap =
[
% to:   0  1  2  3  4  5  6
        0,17, 3,20,11,11, 3, % from 0
       11, 0,12,18, 5, 6, 4, % from 1
        7, 2, 0,15,13,20,18, % from 2
        7, 4, 2, 0, 2,15, 3, % from 3
       19,12,16, 4, 0,19, 4, % from 4
       13,20,10,14,15, 0, 1, % from 5
        3, 3, 6,20, 9,10, 0  % from 6
];

int: maxCap = max([cap[i,j] | i in N, j in N]);

array[N, N] of var 0..maxCap: f;

% Capacity constraints and no self-flow
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j] /\ (i = j -> f[i,j] = 0 else true)
);

% Flow conservation at intermediate nodes (excluding s and t)
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

var 0..sum(j in N)(cap[s,j]): flowValue =
  sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

constraint flowValue = sum(i in N)(f[i,t]) - sum(j in N)(f[t,j]);

solve maximize flowValue;

output [
  "Maximum transferable data from Station ", show(s), " to Station ", show(t), " in one hour: ",
  show(flowValue), " TB\n"
];