% Parameters
int: num_pieces;
int: num_players;
array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of 0..1: rehearsal;

% Variables
array[1..num_pieces] of var 1..num_pieces: order; % order of pieces
array[1..num_players, 1..num_pieces] of var 0..1: presence; % presence of players

% Constraints
include "alldifferent.mzn";
constraint alldifferent(order);

% Each player is present for the pieces they are involved in
constraint forall(i in 1..num_players, j in 1..num_pieces) (
    presence[i, order[j]] = rehearsal[i, j]
);

% Each player arrives at the first piece they are involved in and leaves after the last piece they are involved in
constraint forall(i in 1..num_players) (
    sum(j in 1..num_pieces) (presence[i, j]) = sum(j in 1..num_pieces) (rehearsal[i, j])
);

% Objective
var int: total_waiting_time = sum(i in 1..num_players, j in 1..num_pieces) (presence[i, j] * duration[j]);
solve minimize total_waiting_time;