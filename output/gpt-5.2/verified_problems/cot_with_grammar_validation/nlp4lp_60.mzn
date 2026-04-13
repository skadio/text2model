% Parameters
int: N;
int: W;

array[1..N, 1..W-1] of float: WestTime;
array[1..N-1, 1..W] of float: NorthTime;

% Variables
set of int: Streets = 1..N;
set of int: Avenues = 1..W;

array[Streets, Avenues] of var bool: visit;            % whether intersection (n,w) is on the path
array[Streets, 1..W-1] of var bool: useWest;           % edge (n,w)->(n,w+1)
array[1..N-1, Avenues] of var bool: useNorth;          % edge (n,w)->(n+1,w)

var float: totalTime;

% Constraints
constraint visit[1,1] = true;
constraint visit[N,W] = true;

% Flow conservation: along the path, each visited node has the right number of incident edges
constraint forall(n in Streets, w in Avenues where not (n=1 /\ w=1) /\ not (n=N /\ w=W)) (
  let {
    var int: inDeg =
      (if w > 1 then bool2int(useWest[n,w-1]) else 0 endif) +
      (if n > 1 then bool2int(useNorth[n-1,w]) else 0 endif),
    var int: outDeg =
      (if w < W then bool2int(useWest[n,w]) else 0 endif) +
      (if n < N then bool2int(useNorth[n,w]) else 0 endif)
  } in
    inDeg = bool2int(visit[n,w]) /\ outDeg = bool2int(visit[n,w])
);

% Start has exactly one outgoing and no incoming
constraint
  (if W > 1 then bool2int(useWest[1,1]) else 0 endif) +
  (if N > 1 then bool2int(useNorth[1,1]) else 0 endif) = 1;
constraint
  (if W > 1 then 0 else 0 endif) + (if N > 1 then 0 else 0 endif) = 0;

% End has exactly one incoming and no outgoing
constraint
  (if W > 1 then bool2int(useWest[N,W-1]) else 0 endif) +
  (if N > 1 then bool2int(useNorth[N-1,W]) else 0 endif) = 1;
constraint
  (if W > 1 then 0 else 0 endif) + (if N > 1 then 0 else 0 endif) = 0;

% Edges imply their endpoint intersections are visited
constraint forall(n in Streets, w in 1..W-1) (
  useWest[n,w] -> (visit[n,w] /\ visit[n,w+1])
);
constraint forall(n in 1..N-1, w in Avenues) (
  useNorth[n,w] -> (visit[n,w] /\ visit[n+1,w])
);

% Total time
constraint totalTime =
  sum(n in Streets, w in 1..W-1) (WestTime[n,w] * bool2float(useWest[n,w])) +
  sum(n in 1..N-1, w in Avenues) (NorthTime[n,w] * bool2float(useNorth[n,w]));

% Objective
solve minimize totalTime;