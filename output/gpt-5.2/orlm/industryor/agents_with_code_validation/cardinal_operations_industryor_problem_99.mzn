% Parameters
int: n = 5;                               % number of nodes
set of int: N = 1..n;                     % node index set

% Node indices (A=1, B=2, C=3, D=4, E=5)
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[N, N] of int: bw =                  % bandwidth matrix (0 = no direct link)
  [| 0,  90, 85,  0, 65
   | 95,  0, 70, 65, 34
   | 60,  0,  0, 88, 80
   | 67, 30, 25,  0, 84
   |  0, 51,  0, 56,  0 |];

int: maxBW = max([bw[i,j] | i in N, j in N]);  % upper bound for path bandwidth variable


% Variables
array[N, N] of var bool: use;             % use[i,j] = true if arc i->j is in the chosen path
array[N] of var 0..1: visit;              % visit[i] = 1 if node i is on the path (including A and E)
array[N] of var 0..n: pos;                % topological position to eliminate loops (acyclic path)
var 0..maxBW: path_bw;                    % bandwidth of the chosen A->E path via C (min arc bw on path)


% Constraints

% --- Arc feasibility: can only use existing directed links (bw > 0) ---
constraint
  forall(i in N, j in N) (
    use[i,j] -> (bw[i,j] > 0 /\ i != j)
  );

% --- Basic visitation: A, C, E must be on the path ---
constraint visit[A] = 1;
constraint visit[C] = 1;
constraint visit[E] = 1;

% --- Link use implies both endpoints are visited ---
constraint
  forall(i in N, j in N) (
    use[i,j] -> (visit[i] = 1 /\ visit[j] = 1)
  );

% --- Degree constraints: enforce a single simple directed path from A to E ---
% A: exactly one outgoing, no incoming
constraint sum(j in N)(bool2int(use[A,j])) = 1;
constraint sum(i in N)(bool2int(use[i,A])) = 0;

% E: exactly one incoming, no outgoing
constraint sum(i in N)(bool2int(use[i,E])) = 1;
constraint sum(j in N)(bool2int(use[E,j])) = 0;

% For intermediate nodes (including C): if visited then exactly one in and one out, else none
constraint
  forall(v in N where v != A /\ v != E) (
    sum(i in N)(bool2int(use[i,v])) = visit[v] /\
    sum(j in N)(bool2int(use[v,j])) = visit[v]
  );

% --- Enforce that C is on the A->E path in the correct order using topological positions ---
constraint pos[A] = 1;
constraint pos[A] < pos[C];
constraint pos[C] < pos[E];

% Positions only matter for visited nodes; keep them 0 otherwise
constraint
  forall(v in N) (
    (visit[v] = 0 -> pos[v] = 0) /\
    (visit[v] = 1 -> pos[v] >= 1)
  );

% --- Acyclicity / no loops: all chosen arcs go from lower to higher position ---
constraint
  forall(i in N, j in N) (
    use[i,j] -> (pos[i] < pos[j])
  );

% --- Path bandwidth definition: path_bw is <= every used arc bandwidth, and equals min over used arcs ---
% Upper bound by every used arc
constraint
  forall(i in N, j in N) (
    use[i,j] -> path_bw <= bw[i,j]
  );

% Tightening: path_bw must match at least one used arc bandwidth (so it is the minimum)
constraint
  exists(i in N, j in N) (
    use[i,j] /\ path_bw = bw[i,j]
  );


% Objective
solve maximize path_bw;