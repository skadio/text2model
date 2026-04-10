include "globals.mzn";

% Max flow from source s=0 to sink t=7 on a directed capacitated network.
% Units: thousands of vehicles per hour.

int: n = 8;
set of int: N = 0..n-1;
int: s = 0;
int: t = 7;

array[N, N] of int: cap =
[
 % to:  0  1  2  3  4  5  6  7
        0,18, 5, 6, 8,10,16, 0,  % from 0
       18, 0, 1,15,20,13, 1, 2,  % from 1
       18,16, 0,19,15, 4, 9,10,  % from 2
       20, 2,18, 0,19,17,15,19,  % from 3
       14,13,14, 1, 0, 8,16,20,  % from 4
        0,17,18,10,17, 0,16, 6,  % from 5
        5,14,19, 6, 0,19, 0,12,  % from 6
        7,16,17,13, 6, 9, 5, 0   % from 7
];

int: U = max([cap[i,j] | i in N, j in N]);

% Flow variables on every directed arc (including those with 0 capacity -> forced to 0)
array[N, N] of var 0..U: f;

% Capacity constraints
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j]
);

% No self-flow
constraint forall(i in N) ( f[i,i] = 0 );

% Flow conservation on intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Define value of the flow: net out of source (equals net into sink by conservation)
var 0..sum(j in N)(cap[s,j]): maxFlow =
  sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

solve maximize maxFlow;

output [
  "Maximum flow (thousands of vehicles per hour) = ", show(maxFlow), "\n",
  "Flow matrix f[from,to] (0..7):\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j])
                   | j in N ]) ++ "\n"
          | i in N ])
];