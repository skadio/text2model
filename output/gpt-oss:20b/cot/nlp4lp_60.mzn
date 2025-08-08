% Parameters
int: N;
int: W;
array[1..N, 1..W-1] of float: WestTime;
array[1..N-1, 1..W] of float: NorthTime;

% Variables
array[1..W, 1..N] of var float: dp;

% Constraints
constraint dp[W][N] = 0.0;

constraint forall(w in 1..W, n in 1..N) (
  if w < W /\ n < N then
    dp[w][n] = min(dp[w+1][n] + WestTime[n,w], dp[w][n+1] + NorthTime[n,w])
  else if w < W /\ n = N then
    dp[w][n] = dp[w+1][n] + WestTime[n,w]
  else if w = W /\ n < N then
    dp[w][n] = dp[w][n+1] + NorthTime[n,w]
  else
    true
);

% Objective
solve minimize dp[1][1];