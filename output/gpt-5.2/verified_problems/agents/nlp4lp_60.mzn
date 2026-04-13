% Parameters
int: N; % Number of east-west streets (rows of intersections)
int: W; % Number of north-south avenues (columns of intersections)

array[1..N, 1..W-1] of float: WestTime;  % Time to move one block west from (n,w) -> (n,w+1) in index terms dist[1,w]=dist[1,w-1]+WestTime[1,w-1]
array[1..N-1, 1..W] of float: NorthTime; % Time to move one block north from (n,w) -> (n+1,w)

% Useful index sets
set of int: Streets  = 1..N;
set of int: Avenues  = 1..W;

% Variables
array[Streets, Avenues] of var float: dist;
% dist[n,w] = travel time from start (1,1) to intersection (n,w)

array[Streets, Avenues] of var bool: takeNorth;
% takeNorth[n,w] = true if predecessor into (n,w) is from (n-1,w) (meaningful for n>=2)

array[Streets, Avenues] of var bool: takeWest;
% takeWest[n,w] = true if predecessor into (n,w) is from (n,w-1) (meaningful for w>=2)

% Constraints

%------------------------------------------------------------
% Base case: starting intersection has zero travel time
%------------------------------------------------------------
constraint dist[1,1] = 0.0;

%------------------------------------------------------------
% Boundary propagation: first street (n=1) can only be reached by moving west
% dist[1,w] = dist[1,w-1] + WestTime[1,w-1]
%------------------------------------------------------------
constraint forall(w in 2..W) (
  dist[1,w] = dist[1,w-1] + WestTime[1, w-1]
);

%------------------------------------------------------------
% Boundary propagation: first avenue (w=1) can only be reached by moving north
% dist[n,1] = dist[n-1,1] + NorthTime[n-1,1]
%------------------------------------------------------------
constraint forall(n in 2..N) (
  dist[n,1] = dist[n-1,1] + NorthTime[n-1, 1]
);

%------------------------------------------------------------
% Boundary decision flags: enforce which move is used on boundaries
%------------------------------------------------------------
constraint forall(w in 2..W) (
  takeWest[1,w] /\ not takeNorth[1,w]
);
constraint forall(n in 2..N) (
  takeNorth[n,1] /\ not takeWest[n,1]
);

% Start cell has no predecessor choice
constraint (not takeNorth[1,1]) /\ (not takeWest[1,1]);

%------------------------------------------------------------
% Interior cells: choose exactly one predecessor (north or west)
%------------------------------------------------------------
constraint forall(n in 2..N, w in 2..W) (
  bool2int(takeNorth[n,w]) + bool2int(takeWest[n,w]) = 1
);

%------------------------------------------------------------
% Interior distance recursion: dist equals the chosen predecessor plus the corresponding edge time
% - From north: (n-1,w) -> (n,w) uses NorthTime[n-1,w]
% - From west : (n,w-1) -> (n,w) uses WestTime[n,w-1]
%------------------------------------------------------------
constraint forall(n in 2..N, w in 2..W) (
  dist[n,w] =
    bool2int(takeNorth[n,w]) * (dist[n-1,w] + NorthTime[n-1,w]) +
    bool2int(takeWest[n,w])  * (dist[n,w-1] + WestTime[n, w-1])
);

% Objective
solve minimize dist[N, W];