int: N; % number of east-west streets (rows)
int: W; % number of north-south streets (columns)

array[1..N, 1..W-1] of float: WestTime;     % move west from (n,w+1) -> (n,w)
array[1..N-1, 1..W] of float: NorthTime;    % move north from (n,w) -> (n+1,w)

set of int: Streets = 1..N;
set of int: Avenues = 1..W;

% Dynamic programming: dp[n,w] = minimal time from (1,1) to (n,w)
array[Streets, Avenues] of var float: dp;

% Optional: predecessor direction for a shortest path reconstruction
% 0 = start, 1 = came from south (i.e., last move was north), 2 = came from east (i.e., last move was west)
array[Streets, Avenues] of var 0..2: pred;

constraint dp[1,1] = 0.0;
constraint pred[1,1] = 0;

% First street (n=1): can only move west along avenues? From (1,1) to (1,w) uses west moves? Actually movement allowed north or west.
% Starting at (1,1) and moving west would decrease avenue index; impossible. So along n=1 we can only reach increasing w by "east",
% but east is not allowed. Therefore we interpret coordinates as (street index increases north, avenue index decreases west),
% and target is (N,W) meaning W is westward from 1. Thus moving west increases avenue index.
% Under this convention:
% - West move: (n,w) -> (n,w+1) costs WestTime[n,w] for w in 1..W-1
% - North move: (n,w) -> (n+1,w) costs NorthTime[n,w] for n in 1..N-1

% First street: only west moves
constraint forall(w in 2..W) (
  dp[1,w] = dp[1,w-1] + WestTime[1,w-1] /\
  pred[1,w] = 2
);

% First avenue: only north moves
constraint forall(n in 2..N) (
  dp[n,1] = dp[n-1,1] + NorthTime[n-1,1] /\
  pred[n,1] = 1
);

% Interior: min of coming from south (north move) or from east (west move)
constraint forall(n in 2..N, w in 2..W) (
  dp[n,w] = min(
              dp[n-1,w] + NorthTime[n-1,w],
              dp[n,w-1] + WestTime[n,w-1]
            ) /\
  pred[n,w] = if dp[n-1,w] + NorthTime[n-1,w] <= dp[n,w-1] + WestTime[n,w-1] then 1 else 2 endif
);

var float: Time = dp[N,W];

solve minimize Time;

output [
  "Time = ", show(Time), "\n"
];