% Parameters
int: N; % Number of east-west streets (rows of intersections)
int: W; % Number of north-south avenues (columns of intersections)

set of int: STREETS = 1..N;        % Street indices (south to north)
set of int: AVENUES = 1..W;        % Avenue indices (east to west)
set of int: STREET_SEGS = 1..N;    % For west moves, indexed by street
set of int: AVE_SEGS = 1..(W-1);   % West-moving segments along an avenue gap
set of int: NORTH_SEGS = 1..(N-1); % North-moving segments along a street gap

array[STREET_SEGS, AVE_SEGS] of float: WestTime;
% WestTime[n,w] = time to go west from intersection (n, w+1) to (n, w)

array[NORTH_SEGS, AVENUES] of float: NorthTime;
% NorthTime[n,w] = time to go north from intersection (n, w) to (n+1, w)


% Variables
array[STREETS, AVENUES] of var bool: visit;
% visit[n,w] = true if the path visits intersection (n,w)

array[STREET_SEGS, AVE_SEGS] of var bool: goWest;
% goWest[n,w] = true if the path uses the west edge on street n between avenues (w+1 -> w)

array[NORTH_SEGS, AVENUES] of var bool: goNorth;
% goNorth[n,w] = true if the path uses the north edge on avenue w between streets (n -> n+1)

var float: totalTime;
% Total walking time of the chosen path


% Constraints

%--------------------------------------------------------------------
% Start and destination intersections must be visited
% (Start at (1,1); destination at (N,W))
%--------------------------------------------------------------------
constraint visit[1, 1];
constraint visit[N, W];

%--------------------------------------------------------------------
% Edge usage implies visiting both endpoint intersections
%--------------------------------------------------------------------
constraint
  forall(n in STREET_SEGS, w in AVE_SEGS) (
    goWest[n, w] -> (visit[n, w] /\ visit[n, w+1])
  );

constraint
  forall(n in NORTH_SEGS, w in AVENUES) (
    goNorth[n, w] -> (visit[n, w] /\ visit[n+1, w])
  );

%--------------------------------------------------------------------
% Flow conservation for intermediate intersections:
% If an intersection is visited (and is not start/end), exactly one edge enters
% and exactly one edge leaves (directed north or west).
%
% Direction conventions:
% - West edge: from (n, w+1) -> (n, w)  (goWest[n,w])
% - North edge: from (n, w) -> (n+1, w) (goNorth[n,w])
%--------------------------------------------------------------------
constraint
  forall(n in STREETS, w in AVENUES
         where not (n = 1 /\ w = 1) /\ not (n = N /\ w = W)) (
    let {
      var int: inDeg =
          bool2int(n > 1) * bool2int(goNorth[n-1, w]) +
          bool2int(w < W) * bool2int(goWest[n, w]),
      var int: outDeg =
          bool2int(n < N) * bool2int(goNorth[n, w]) +
          bool2int(w > 1) * bool2int(goWest[n, w-1])
    } in
      (visit[n, w] <-> (inDeg = 1 /\ outDeg = 1))
  );

%--------------------------------------------------------------------
% Start node: no incoming edge, exactly one outgoing edge
% Outgoing from (1,1) can only be North (if N>1) or West (if W>1).
% Note: goWest[1,1] corresponds to edge (1,2)->(1,1), i.e., it is NOT
% an outgoing edge from (1,1). Hence only goNorth[1,1] can be outgoing.
% With the stated movement restrictions (north or west), starting at (1,1)
% implies W must be 1 or the destination must be reachable only by north moves.
% The original constraint is kept as given.
%--------------------------------------------------------------------
constraint
  let {
    var int: outStart =
        bool2int(N > 1) * bool2int(goNorth[1, 1]) +
        bool2int(W > 1) * bool2int(goWest[1, 1]),
    var int: inStart = 0
  } in
    (inStart = 0) /\ (outStart = 1);

%--------------------------------------------------------------------
% Destination node: exactly one incoming edge, no outgoing edge
%--------------------------------------------------------------------
constraint
  let {
    var int: inEnd =
        bool2int(N > 1) * bool2int(goNorth[N-1, W]) +
        bool2int(W > 1) * bool2int(goWest[N, W-1]),
    var int: outEnd = 0
  } in
    (inEnd = 1) /\ (outEnd = 0);

%--------------------------------------------------------------------
% Total time equals sum of chosen segment times
%--------------------------------------------------------------------
constraint
  totalTime =
    sum(n in STREET_SEGS, w in AVE_SEGS) (WestTime[n, w] * bool2int(goWest[n, w])) +
    sum(n in NORTH_SEGS,  w in AVENUES)  (NorthTime[n, w] * bool2int(goNorth[n, w]));


% Objective
solve minimize totalTime;