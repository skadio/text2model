include "globals.mzn";

/* ----- data ----- */
int: N;                     % number of east‑west streets  (rows)
int: W;                     % number of north‑south streets (columns)

array[1..N, 1..W-1] of float: WestTime;   % time to move east (from (n,w) to (n,w+1))
array[1..N-1, 1..W] of float: NorthTime; % time to move north (from (n,w) to (n+1,w))

/* ----- decision variables ----- */
array[1..N, 1..W-1] of var 0..1: takeWest;   % 1 if the path goes east from (n,w)
array[1..N-1, 1..W] of var 0..1: takeNorth; % 1 if the path goes north from (n,w)

/* ----- flow constraints ----- */
/* start node (1,1) must have exactly one outgoing edge */
constraint
    (if W > 1 then takeWest[1,1] else 0) +
    (if N > 1 then takeNorth[1,1] else 0) = 1;

/* destination node (N,W) must have exactly one incoming edge */
constraint
    (if W > 1 then takeWest[N,W-1] else 0) +
    (if N > 1 then takeNorth[N-1,W] else 0) = 1;

/* all other nodes: one incoming and one outgoing edge */
constraint
    forall(n in 1..N, w in 1..W where !(n==1 /\ w==1) /\ !(n==N /\ w==W)) (
        let {
            var int: inc = (if n > 1 then takeNorth[n-1,w] else 0) +
                           (if w > 1 then takeWest[n,w-1] else 0);
            var int: out = (if n < N then takeNorth[n,w] else 0) +
                           (if w < W then takeWest[n,w] else 0);
        } in
        inc = 1 /\ out = 1
    );

/* ----- objective ----- */
var float: totalTime =
    sum([ NorthTime[n,w] * takeNorth[n,w] | n in 1..N-1, w in 1..W ])
  + sum([ WestTime[n,w] * takeWest[n,w]   | n in 1..N,   w in 1..W-1 ]);

solve minimize totalTime;

/* ----- output ----- */
output [
  "Minimum total time = ", show(totalTime), "\n",
  "\nNorth moves (1 = taken, 0 = not taken):\n", show(takeNorth), "\n",
  "\nWest  moves (1 = taken, 0 = not taken):\n", show(takeWest), "\n"
];