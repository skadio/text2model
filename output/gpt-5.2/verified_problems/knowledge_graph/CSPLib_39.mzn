include "globals.mzn";

int: num_pieces;
int: num_players;

set of int: PIECES = 1..num_pieces;
set of int: PLAYERS = 1..num_players;

array[PIECES] of int: duration;                         % duration[p]
array[PLAYERS, PIECES] of bool: rehearsal;              % rehearsal[player, piece] true iff player plays in piece

% Order of pieces in the rehearsal (a permutation of 1..num_pieces)
array[PIECES] of var PIECES: order;
constraint all_different(order);

% Start time of each position in the order
array[PIECES] of int: start_time =
  [ if k = 1 then 0 else sum(i in 1..k-1)(duration[order[i]]) endif | k in PIECES ];

int: total_duration = sum(p in PIECES)(duration[p]);

% For each player: first and last position in the order where they play
array[PLAYERS] of var PIECES: firstPos;
array[PLAYERS] of var PIECES: lastPos;

constraint
  forall(pl in PLAYERS) (
    sum(k in PIECES)(bool2int(rehearsal[pl, order[k]])) >= 1 /\
    firstPos[pl] <= lastPos[pl] /\
    forall(k in PIECES) (
      (k < firstPos[pl]) -> not rehearsal[pl, order[k]]
    ) /\
    forall(k in PIECES) (
      (k > lastPos[pl]) -> not rehearsal[pl, order[k]]
    ) /\
    rehearsal[pl, order[firstPos[pl]]] /\
    rehearsal[pl, order[lastPos[pl]]]
  );

% Waiting time per player:
% presence interval length (from start of first piece they play to end of last piece they play)
% minus total playing time (sum of durations of pieces they play)
array[PLAYERS] of var int: wait_time;

constraint
  forall(pl in PLAYERS) (
    wait_time[pl] =
      (start_time[lastPos[pl]] + duration[order[lastPos[pl]]] - start_time[firstPos[pl]])
      - sum(k in PIECES)( bool2int(rehearsal[pl, order[k]]) * duration[order[k]] )
  );

var int: total_wait = sum(pl in PLAYERS)(wait_time[pl]);

solve minimize total_wait;

output [
  "total_wait = ", show(total_wait), "\n",
  "order = ", show(order), "\n",
  "wait_time = ", show(wait_time), "\n"
];