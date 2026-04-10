% Parameters
int: N = 5;
set of int: V = 1..N;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[V, V] of int: bw =
  [| 0, 90, 85,  0, 65
   | 95,  0, 70, 65, 34
   | 60,  0,  0, 88, 80
   | 67, 30, 25,  0, 84
   |  0, 51,  0, 56,  0 |];

int: maxBW = max([bw[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..1: x;            % x[i,j]=1 if arc i->j is used in the path
array[V] of var 0..1: used;            % node used in path (for subtour elimination)
array[V] of var 1..N: ord;             % ordering for MTZ subtour elimination
var 0..maxBW: T;                       % bottleneck bandwidth to maximize

% Constraints
constraint forall(i in V, j in V) (x[i,j] = 0 \/ bw[i,j] > 0); % only use existing links
constraint forall(i in V) (x[i,i] = 0);

% Flow conservation for a single A->E path
constraint sum(j in V)(x[A,j]) = 1;
constraint sum(i in V)(x[i,A]) = 0;

constraint sum(i in V)(x[i,E]) = 1;
constraint sum(j in V)(x[E,j]) = 0;

constraint forall(v in V where v != A /\ v != E) (
  sum(i in V)(x[i,v]) = sum(j in V)(x[v,j])
);

% Must pass through service node C
constraint sum(i in V)(x[i,C]) = 1;
constraint sum(j in V)(x[C,j]) = 1;

% Define used nodes
constraint used[A] = 1;
constraint used[E] = 1;
constraint used[C] = 1;
constraint forall(v in V) (
  used[v] = bool2int( (sum(i in V)(x[i,v]) + sum(j in V)(x[v,j])) > 0 )
);

% No loops/subtours: MTZ constraints on used nodes
constraint ord[A] = 1;
constraint forall(v in V) (ord[v] <= 1 + (N-1)*used[v]);
constraint forall(i in V, j in V where i != j) (
  ord[i] + 1 <= ord[j] + N*(1 - x[i,j])
);

% Bottleneck definition: T is <= bandwidth of every used arc
constraint forall(i in V, j in V) (
  T <= bw[i,j] + maxBW*(1 - x[i,j])
);

% Objective
solve maximize T;