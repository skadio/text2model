include "globals.mzn";

int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal;

array[1..num_pieces] of var 1..num_pieces: piece;

array[1..num_players, 1..num_pieces] of var 0..1: play_at_pos;

array[1..num_pieces] of var int: start_time;
array[1..num_pieces] of var int: end_time;

array[1..num_players] of var 1..num_pieces: first_pos;
array[1..num_players] of var 1..num_pieces: last_pos;

array[1..num_players] of var int: total_playing_time;
array[1..num_players] of var int: presence_time;
array[1..num_players] of var int: waiting_time;

var int: total_waiting_time;

constraint alldifferent(piece);

constraint
  forall(pl in 1..num_players, k in 1..num_pieces) (
    play_at_pos[pl,k] = rehearsal[pl, piece[k]]
  );

constraint
  forall(pl in 1..num_players) (
    sum(k in 1..num_pieces)(play_at_pos[pl,k]) >= 1
  );

constraint start_time[1] = 0;
constraint end_time[1] = duration[piece[1]];
constraint
  forall(k in 2..num_pieces) (
    start_time[k] = end_time[k-1] /\
    end_time[k] = start_time[k] + duration[piece[k]]
  );

constraint
  forall(pl in 1..num_players) (
    first_pos[pl] = min([k | k in 1..num_pieces where play_at_pos[pl,k] = 1]) /\
    last_pos[pl]  = max([k | k in 1..num_pieces where play_at_pos[pl,k] = 1])
  );

constraint
  forall(pl in 1..num_players) (
    total_playing_time[pl] =
      sum(k in 1..num_pieces)(play_at_pos[pl,k] * duration[piece[k]])
  );

constraint
  forall(pl in 1..num_players) (
    presence_time[pl] = end_time[last_pos[pl]] - start_time[first_pos[pl]]
  );

constraint
  forall(pl in 1..num_players) (
    waiting_time[pl] = presence_time[pl] - total_playing_time[pl]
  );

constraint total_waiting_time = sum(pl in 1..num_players)(waiting_time[pl]);

solve minimize total_waiting_time;