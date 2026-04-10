% Shortest path on an (N-1) x (W-1) grid moving only North or West

int: N; % number of east-west streets (1..N)
int: W; % number of north-south avenues (1..W)

% WestTime[n,w] = time to go west along street n from avenue w to w+1
array[1..N, 1..W-1] of float: WestTime;

% NorthTime[n,w] = time to go north along avenue w from street n to n+1
array[1..N-1, 1..W] of float: NorthTime;

set of int: Streets = 1..N;
set of int: Aves    = 1..W;

% Decision: whether to use each directed edge (only North and West exist)
array[1..N-1, 1..W] of var 0..1: useN;     % from (n,w) -> (n+1,w)
array[1..N, 1..W-1] of var 0..1: useW;     % from (n,w+1) -> (n,w) i.e., west move along street n at segment w

% Flow balance at each node (n,w):
% incoming - outgoing = 1 at source (1,1), = -1 at sink (N,W), else 0
function var int: inFlow(int: n, int: w) =
    (if n > 1 then useN[n-1,w] else 0 endif) +
    (if w < W then useW[n,w] else 0 endif);

function var int: outFlow(int: n, int: w) =
    (if n < N then useN[n,w] else 0 endif) +
    (if w > 1 then useW[n,w-1] else 0 endif);

constraint
  forall(n in Streets, w in Aves) (
    inFlow(n,w) - outFlow(n,w) =
      (if n = 1 /\ w = 1 then 1
       elseif n = N /\ w = W then -1
       else 0 endif)
  );

% Objective: minimize total time
var float: totalTime =
  sum(n in 1..N-1, w in 1..W)( NorthTime[n,w] * int2float(useN[n,w]) ) +
  sum(n in 1..N,   w in 1..W-1)( WestTime[n,w]  * int2float(useW[n,w]) );

solve minimize totalTime;

output [
  "totalTime = ", show(totalTime), "\n",
  "useN (north edges, n=1..N-1, w=1..W):\n", show(useN), "\n",
  "useW (west edges, n=1..N, w=1..W-1):\n", show(useW), "\n"
];