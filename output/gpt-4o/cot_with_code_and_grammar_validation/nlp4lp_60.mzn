% Parameters
int: N;                                   % Number of east-west streets
int: W;                                   % Number of north-south streets

array[1..N, 1..W-1] of float: WestTime;   % Time to walk one block west
array[1..N-1, 1..W] of float: NorthTime;  % Time to walk one block north


% Derived index sets
set of int: Streets  = 1..N;
set of int: Avenues  = 1..W;
set of int: WestSeg  = 1..W-1;
set of int: NorthSeg = 1..N-1;


% Decision variables
array[Streets, WestSeg]  of var 0..1: useWest;   % 1 if the westward edge is taken
array[NorthSeg, Avenues] of var 0..1: useNorth;  % 1 if the northward edge is taken


% 1. Required number of steps in each direction
constraint
    sum(n in Streets, w in WestSeg)(useWest[n, w]) = W - 1;

constraint
    sum(n in NorthSeg, w in Avenues)(useNorth[n, w]) = N - 1;


% 2. Flow conservation at interior intersections
constraint
    forall(n in Streets, w in Avenues
           where not (n = 1 /\ w = 1) /\ not (n = N /\ w = W)) (
        ( (if n < N then useNorth[n,     w ] else 0 endif) +
          (if w < W then useWest [n,     w ] else 0 endif) )
      =
        ( (if n > 1 then useNorth[n-1, w ] else 0 endif) +
          (if w > 1 then useWest [n,   w-1] else 0 endif) )
    );


% 3. Start intersection (1,1): exactly one outgoing edge
constraint
    ( (if 1 < N then useNorth[1,1] else 0 endif) +
      (if 1 < W then useWest [1,1] else 0 endif) ) = 1;


% 4. Destination intersection (N,W): exactly one incoming edge
constraint
    ( (if N > 1 then useNorth[N-1, W] else 0 endif) +
      (if W > 1 then useWest [N,   W-1] else 0 endif) ) = 1;


% Objective
var float: total_time =
      sum(n in Streets, w in WestSeg)
          (WestTime [n, w] * int2float(useWest [n, w]))
    + sum(n in NorthSeg, w in Avenues)
          (NorthTime[n, w] * int2float(useNorth[n, w]));

solve minimize total_time;