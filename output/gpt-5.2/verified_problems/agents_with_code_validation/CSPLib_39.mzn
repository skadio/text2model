include "globals.mzn";

% Parameters
int: num_pieces;                         % Number of pieces in the concert
int: num_players;                        % Number of players in the orchestra

array[1..num_pieces] of int: duration;   % Duration of each piece (assumed non-negative)
array[1..num_players, 1..num_pieces] of int: rehearsal;
% rehearsal[p, i] indicates whether player p is involved in piece i (typically 0/1)

% Useful index sets
set of int: PIECES  = 1..num_pieces;
set of int: PLAYERS = 1..num_players;

% Variables
array[PIECES] of var PIECES: order;
% order[t] = which piece is rehearsed in position t (a permutation of pieces)

array[PIECES] of var PIECES: pos;
% pos[i] = position at which piece i is rehearsed (inverse permutation)

var 0..sum(duration): total_waiting_time;

array[PLAYERS] of var 0..sum(duration): waiting_time_player;

% Constraints

% --- Permutation / inverse-permutation channeling ---
constraint all_different(order);
constraint all_different(pos);

constraint forall(t in PIECES) (
  pos[order[t]] = t
);

% --- Per-player presence window and waiting-time computation ---
constraint
  forall(p in PLAYERS) (
    let {
      array[int] of var int: involved_pos = [ pos[i] | i in PIECES where rehearsal[p,i] != 0 ],
      var int: first_p = min(involved_pos),
      var int: last_p  = max(involved_pos),

      var int: span_p =
        sum(t in PIECES) (
          bool2int(first_p <= t /\ t <= last_p) * duration[order[t]]
        ),

      var int: play_p =
        sum(i in PIECES) (
          bool2int(rehearsal[p,i] != 0) * duration[i]
        )
    } in
      waiting_time_player[p] = span_p - play_p
  );

% --- Total waiting time aggregation ---
constraint total_waiting_time = sum(p in PLAYERS)(waiting_time_player[p]);

% Objective
solve minimize total_waiting_time;