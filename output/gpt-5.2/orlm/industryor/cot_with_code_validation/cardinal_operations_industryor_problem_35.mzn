include "globals.mzn";

%-------------------------
% Data (embedded)
%-------------------------
int: Ncust = 20;
int: N = Ncust + 1;              % nodes 1..N (1 = depot, 2..N = customers)
set of int: V = 1..N;
set of int: C = 2..N;

int: K = 5;
set of int: Veh = 1..K;

int: Q = 200;

array[V] of int: x = [40, 45, 45, 42, 42, 42, 40, 40, 38, 38, 35, 35, 25, 22, 22, 20, 20, 18, 15, 15, 30];
array[V] of int: y = [50, 68, 70, 66, 68, 65, 69, 66, 68, 70, 66, 69, 85, 75, 85, 80, 85, 75, 75, 80, 50];

array[V] of int: demand =
  [0, 10, 30, 10, 10, 10, 20, 20, 20, 10, 10, 10, 20, 30, 10, 40, 40, 20, 20, 10, 10];

array[V] of int: tw_start =
  [0, 912, 825, 65, 727, 15, 621, 170, 255, 534, 357, 448, 652, 30, 567, 384, 475, 99, 179, 278, 10];
array[V] of int: tw_end =
  [1236, 967, 870, 146, 782, 67, 702, 225, 324, 605, 410, 505, 721, 92, 620, 429, 528, 148, 254, 345, 73];

array[V] of int: service = [0] ++ [90 | i in 1..Ncust];

int: Tmax = max(tw_end);

% Use Manhattan distance to avoid expensive sqrt/round at compile time
array[V, V] of int: dist =
  array2d(V, V,
    [ abs(x[i] - x[j]) + abs(y[i] - y[j]) | i in V, j in V ]
  );

% Big-M for time constraints (safe bound based on horizon + max travel + service)
int: maxDist = max([dist[i,j] | i in V, j in V]);
int: Mbig = Tmax + maxDist + 90;

%-------------------------
% Decision variables
%-------------------------
array[Veh, V, V] of var 0..1: arc;     % arc[k,i,j]=1 if vehicle k goes i->j
array[Veh, C] of var 0..1: visit;      % visit[k,i]=1 if vehicle k serves customer i
array[Veh] of var 0..1: used;

array[Veh, V] of var 0..Tmax: t;       % service start time at node

% Total distance (to minimize, but objective type requested is maximization,
% so we maximize the negative distance)
var int: total_distance = sum(k in Veh, i in V, j in V)(dist[i,j] * arc[k,i,j]);

%-------------------------
% Constraints
%-------------------------
% No self loops
constraint forall(k in Veh, i in V)(arc[k,i,i] = 0);

% Vehicle used iff exactly one departure from depot and one return to depot
constraint forall(k in Veh)(
  sum(j in C)(arc[k,1,j]) = used[k] /\
  sum(i in C)(arc[k,i,1]) = used[k]
);

% Each customer visited exactly once overall
constraint forall(i in C)(
  sum(k in Veh)(visit[k,i]) = 1
);

% Flow conservation per vehicle for each customer (in = out = visit)
constraint forall(k in Veh, i in C)(
  sum(j in V)(arc[k,i,j]) = visit[k,i] /\
  sum(j in V)(arc[k,j,i]) = visit[k,i]
);

% Capacity per vehicle
constraint forall(k in Veh)(
  sum(i in C)(demand[i] * visit[k,i]) <= Q
);

% Time windows only if visited; depot always within its window
constraint forall(k in Veh, i in C)(
  t[k,i] >= tw_start[i] - Mbig * (1 - visit[k,i]) /\
  t[k,i] <= tw_end[i]   + Mbig * (1 - visit[k,i])
);

constraint forall(k in Veh)(
  t[k,1] >= tw_start[1] /\
  t[k,1] <= tw_end[1]
);

% Time propagation along arcs (waiting allowed)
constraint forall(k in Veh, i in V, j in V where i != j)(
  t[k,j] >= t[k,i] + service[i] + dist[i,j] - Mbig * (1 - arc[k,i,j])
);

% Limit number of vehicles (already K, but keep explicit)
constraint sum(k in Veh)(used[k]) <= K;

%-------------------------
% Objective (requested type: maximization)
% Minimize distance by maximizing negative distance
%-------------------------
solve maximize (-total_distance);