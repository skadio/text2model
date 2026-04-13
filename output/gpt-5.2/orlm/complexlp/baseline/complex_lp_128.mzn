% Max Flow: Substation 0 (source) to Substation 6 (sink)

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap = array2d(V, V, [
  % to:   0  1  2  3  4  5  6
          0,16, 6,16, 2,17,15,  % from 0
          7, 0,13, 3, 0, 8,17,  % from 1
          3,17, 0,18,11,18,11,  % from 2
          9, 0,15, 0, 3, 8,10,  % from 3
          3, 6, 1,16, 0,13,10,  % from 4
         15,20, 2, 6,18, 0, 9,  % from 5
          4, 6, 8,13,16,10, 0   % from 6
]);

array[V, V] of var 0..20: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% No self-flow
constraint forall(i in V)(f[i,i] = 0);

% Flow conservation for intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

var int: total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Ensure same value is received by sink (redundant but clarifying)
constraint
  total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize total_flow;

output [
  "Maximum flow (MW) = ", show(total_flow), "\n"
];