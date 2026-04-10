int: N; % number of east-west streets (rows)
int: W; % number of north-south streets (columns)

array[1..N, 1..W-1] of float: WestTime;   % move west along street n from avenue w to w+1
array[1..N-1, 1..W] of float: NorthTime;  % move north along avenue w from street n to n+1

set of int: Streets = 1..N;
set of int: Avenues = 1..W;

% dp[n,w] = minimal time to reach intersection (street n, avenue w)
array[Streets, Avenues] of var float: dp;

constraint dp[1,1] = 0.0;

% Along first street (n=1): only west moves
constraint forall(w in 2..W)(
  dp[1,w] = dp[1,w-1] + WestTime[1, w-1]
);

% Along first avenue (w=1): only north moves
constraint forall(n in 2..N)(
  dp[n,1] = dp[n-1,1] + NorthTime[n-1, 1]
);

% Interior: min of coming from south (north move) or from east (west move)
constraint forall(n in 2..N, w in 2..W)(
  dp[n,w] = min(
    dp[n-1,w] + NorthTime[n-1, w],
    dp[n,w-1] + WestTime[n, w-1]
  )
);

solve minimize dp[N,W];

output [
  "MinTime=", show(dp[N,W]), "\n"
];