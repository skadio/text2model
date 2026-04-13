include "globals.mzn";

int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal;

array[1..num_players, 1..num_pieces] of bool: plays =
  array2d(1..num_players, 1..num_pieces, [rehearsal[p,i] != 0 | p in 1..num_players, i in 1..num_pieces]);

array[1..num_pieces] of var 1..num_pieces: pos;
array[1..num_pieces] of var 1..num_pieces: piece_at;

array[1..num_players] of var 1..num_pieces: first_pos;
array[1..num_players] of var 1..num_pieces: last_pos;

array[1..num_players] of var int: presence_time;
array[1..num_players] of var int: play_time;
array[1..num_players] of var int: wait_time;

var int: total_wait;

constraint all_different(pos);
constraint inverse(pos, piece_at);

constraint
  forall(p in 1..num_players)(
    exists(i in 1..num_pieces)(plays[p,i])
  );

constraint
  forall(p in 1..num_players)(
    first_pos[p] = min([pos[i] | i in 1..num_pieces where plays[p,i]]) /\
    last_pos[p]  = max([pos[i] | i in 1..num_pieces where plays[p,i]])
  );

constraint
  forall(p in 1..num_players)(
    play_time[p] = sum(i in 1..num_pieces)(bool2int(plays[p,i]) * duration[i])
  );

constraint
  forall(p in 1..num_players)(
    presence_time[p] =
      sum(t in 1..num_pieces)(
        bool2int(first_pos[p] <= t /\ t <= last_pos[p]) * duration[piece_at[t]]
      )
  );

constraint
  forall(p in 1..num_players)(
    wait_time[p] = presence_time[p] - play_time[p]
  );

constraint total_wait = sum(p in 1..num_players)(wait_time[p]);

solve minimize total_wait;