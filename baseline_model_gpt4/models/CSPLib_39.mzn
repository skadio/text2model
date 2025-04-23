include "globals.mzn";

% Parameters
int: num_pieces;
int: num_players;
array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of 0..1: rehearsal;

% Variables
array[1..num_pieces] of var 1..num_pieces: order; % order of pieces
array[1..num_players, 1..num_pieces] of var 0..num_pieces: wait; % waiting time for each player

% Constraints
constraint alldifferent(order);

% Each player's waiting time is the sum of the durations of the pieces between his first and last piece
constraint forall(i in 1..num_players) (
  let {
    int: first = min([order[j] | j in 1..num_pieces where rehearsal[i,j] = 1]),
    int: last = max([order[j] | j in 1..num_pieces where rehearsal[i,j] = 1])
  } in
  wait[i,first..last] = sum([duration[j] | j in 1..num_pieces where order[j] >= first /\ order[j] <= last /\ rehearsal[i,j] = 0])
);

% Objective
var int: total_wait = sum(i in 1..num_players, j in 1..num_pieces)(wait[i,j]);
solve minimize total_wait;

% Output
output ["order: " ++ show(order) ++ "\n" ++ "total_wait: " ++ show(total_wait)];