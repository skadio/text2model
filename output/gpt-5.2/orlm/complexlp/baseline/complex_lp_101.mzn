% Max flow on a directed network with embedded data

int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
[|  0,  7,  8,  1,  2,  4
 | 15,  0, 16,  0,  9, 13
 |  9,  1,  0,  9, 13, 13
 | 10, 11, 19,  0,  1, 12
 | 15, 16,  7, 11,  0, 19
 | 10, 12, 12, 12, 20,  0 |];

array[V, V] of var 0..20: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint forall(i in V) (f[i,i] = 0);

% Flow conservation at intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

var int: flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize flow;

output [ show(flow) ];