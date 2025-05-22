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
constraint alldifferent(order); % all pieces are different

% each player's presence is determined by the rehearsal schedule and the order of pieces
constraint forall(i in 1..num_players)(
  presence[i, order[1]] = 1 /\ presence[i, order[num_pieces]] = 1
);
constraint forall(i in 1..num_players, j in 2..num_pieces-1)(
  presence[i, order[j]] = max(rehearsal[i, order[j-1]], rehearsal[i, order[j+1]])
);

% Objective
var int: total_waiting_time = sum(i in 1..num_players, j in 1..num_pieces)(
  if presence[i, order[j]] = 1 /\ rehearsal[i, order[j]] = 0 then duration[order[j]] else 0 endif
);
solve minimize total_waiting_time;