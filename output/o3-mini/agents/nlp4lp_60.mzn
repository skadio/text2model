include "globals.mzn";

% Parameters (provided in the data file)
int: N;               % Number of east-west streets (rows)
int: W;               % Number of north-south streets (columns)

% Arrays of crossing times
array[1..N, 1..W-1] of float: WestTime;   % time to move "west" (i.e. from (r,c) to (r, c+1))
array[1..N-1, 1..W] of float: NorthTime;  % time to move north (i.e. from (r,c) to (r+1, c))

% Decision: sequence of moves, total number of moves is (N-1)+(W-1)
int: nMoves = (N - 1) + (W - 1);
enum DIR = {north, west};
array[1..nMoves] of var DIR: move;

% Exactly N-1 north moves and W-1 west moves
constraint count(move, north, N - 1);
constraint count(move, west, W - 1);

% Define the path positions:
% Let path_r[i] and path_c[i] denote the row (street) and column (avenue) at step i, with step 0 being the start.
array[0..nMoves] of var 1..N: path_r;
array[0..nMoves] of var 1..W: path_c;

% Starting at (1,1)
constraint path_r[0] = 1;
constraint path_c[0] = 1;

% Update positions according to the move decisions:
% If move[i] = north, then row increases by 1, column stays the same.
% If move[i] = west, then column increases by 1, row stays the same.
constraint
  forall(i in 1..nMoves) (
    (move[i] = north -> (path_r[i] = path_r[i-1] + 1 /\ path_c[i] = path_c[i-1])) /\
    (move[i] = west  -> (path_r[i] = path_r[i-1] /\ path_c[i] = path_c[i-1] + 1))
  );

% Ensure that moves are only taken when feasible:
% For a north move, you cannot move north from row N.
% For a west move, you cannot move west from column W.
constraint
  forall(i in 1..nMoves) (
    (move[i] = north -> path_r[i-1] < N) /\
    (move[i] = west  -> path_c[i-1] < W)
  );

% The final destination must be (N,W)
constraint path_r[nMoves] = N;
constraint path_c[nMoves] = W;

% Compute the total travel time.
% When at position (r,c), if the move is north then cost = NorthTime[r, c] (r in 1..N-1),
% if the move is west then cost = WestTime[r, c] (c in 1..W-1).
var float: total_time = sum(i in 1..nMoves)(
    if move[i] = north then NorthTime[path_r[i-1], path_c[i-1]]
    else WestTime[path_r[i-1], path_c[i-1]] endif
);

% Objective: minimize the total travel time.
solve minimize total_time;

% Output the optimal sequence of moves, the corresponding path and total travel time.
output [
  "Moves: ", show(move), "\n",
  "Path (row, col): ", 
    show([ (path_r[i], path_c[i]) | i in 0..nMoves ]), "\n",
  "Total time: ", show(total_time), "\n"
];