include "globals.mzn";

% Parameters
int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of bool: rehearsal;

int: T = sum(duration);

% Decision: a permutation giving which piece is rehearsed at each position
array[1..num_pieces] of var 1..num_pieces: piece_at_pos;

% Derived times for each position
array[1..num_pieces] of var 0..T: start_time;
array[1..num_pieces] of var 0..T: end_time;

% Per player: first time present and last time present
array[1..num_players] of var 0..T: first_play_time;
array[1..num_players] of var 0..T: last_play_end;

% Whether player pl plays in the piece at position p
array[1..num_players, 1..num_pieces] of var 0..1: involved_at_pos;

var 0..(num_players * T): total_wait;

% Permutation constraint
constraint all_different(piece_at_pos);

% Build schedule (no gaps)
constraint start_time[1] = 0;
constraint end_time[1] = start_time[1] + duration[piece_at_pos[1]];
constraint forall(p in 2..num_pieces) (
  start_time[p] = end_time[p-1] /\
  end_time[p] = start_time[p] + duration[piece_at_pos[p]]
);

% Link involvement (bool -> int) using element on the piece index
constraint forall(pl in 1..num_players, p in 1..num_pieces) (
  involved_at_pos[pl,p] = bool2int( rehearsal[pl, piece_at_pos[p]] )
);

% Each player must play at least one piece (as per original model assumption)
constraint forall(pl in 1..num_players) (
  sum(p in 1..num_pieces)(involved_at_pos[pl,p]) >= 1
);

% First/last times: use bounds with implications and then optimize to tightness
constraint forall(pl in 1..num_players, p in 1..num_pieces) (
  involved_at_pos[pl,p] = 1 -> first_play_time[pl] <= start_time[p]
);
constraint forall(pl in 1..num_players, p in 1..num_pieces) (
  involved_at_pos[pl,p] = 1 -> last_play_end[pl] >= end_time[p]
);

% Ensure first/last coincide with some involved piece (tighten)
constraint forall(pl in 1..num_players)(
  exists(p in 1..num_pieces)(involved_at_pos[pl,p] = 1 /\ first_play_time[pl] = start_time[p])
);
constraint forall(pl in 1..num_players)(
  exists(p in 1..num_pieces)(involved_at_pos[pl,p] = 1 /\ last_play_end[pl] = end_time[p])
);

% Total waiting time:
% For each player: (time from first arrival to last departure) - (time actually playing)
constraint total_wait =
  sum(pl in 1..num_players)(
    (last_play_end[pl] - first_play_time[pl])
    - sum(p in 1..num_pieces)( duration[piece_at_pos[p]] * involved_at_pos[pl,p] )
  );

solve minimize total_wait;

output [
  "total_wait = ", show(total_wait), "\n",
  "order = ", show(piece_at_pos), "\n"
];