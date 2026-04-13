% Parameters
int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of bool: rehearsal;

% Variables
array[1..num_pieces] of var 1..num_pieces: pos_of_piece;      % position assigned to each piece
array[1..num_pieces] of var 1..num_pieces: piece_at_pos;      % piece scheduled at each position

array[1..num_players] of var 1..num_pieces: first_pos;
array[1..num_players] of var 1..num_pieces: last_pos;

array[1..num_players] of var int: waiting_time_player;
var int: total_waiting_time;

% Constraints
constraint inverse(pos_of_piece, piece_at_pos);

constraint
  forall(pl in 1..num_players) (
    first_pos[pl] = min([ pos_of_piece[p] | p in 1..num_pieces where rehearsal[pl,p] ]) /\
    last_pos[pl]  = max([ pos_of_piece[p] | p in 1..num_pieces where rehearsal[pl,p] ])
  );

constraint
  forall(pl in 1..num_players) (
    waiting_time_player[pl] =
      sum(t in 1..num_pieces)(
        duration[t] * bool2int(
          (pos_of_piece[t] > first_pos[pl]) /\
          (pos_of_piece[t] < last_pos[pl]) /\
          (not rehearsal[pl,t])
        )
      )
  );

constraint total_waiting_time = sum(pl in 1..num_players)(waiting_time_player[pl]);
constraint total_waiting_time >= 0;

% Objective
solve minimize total_waiting_time;