include "globals.mzn";

int: num_pieces;
int: num_players;

set of int: PIECES  = 1..num_pieces;
set of int: PLAYERS = 1..num_players;

array[PIECES]             of int: duration;
array[PLAYERS, PIECES]    of int: rehearsal;

int: horizon = sum(p in PIECES)(duration[p]);

array[PLAYERS] of int: playtime =
  [ sum(p in PIECES)(duration[p] * rehearsal[pl,p]) | pl in PLAYERS ];

array[PIECES]  of var 0..horizon: start;
array[PIECES]  of var 0..horizon: finish;

array[PLAYERS] of var 0..horizon: first_start;
array[PLAYERS] of var 0..horizon: last_finish;
array[PLAYERS] of var 0..horizon: waiting;

var int: total_waiting = sum(pl in PLAYERS)(waiting[pl]);

constraint
  forall(p in PIECES)(
    finish[p] = start[p] + duration[p]
  );

constraint
  disjunctive(start, duration);

constraint
  min(start) = 0;

constraint
  forall(pl in PLAYERS)(
    first_start[pl] = min([ start[p] | p in PIECES where rehearsal[pl,p] = 1 ])
  );

constraint
  forall(pl in PLAYERS)(
    last_finish[pl] = max([ finish[p] | p in PIECES where rehearsal[pl,p] = 1 ])
  );

constraint
  forall(pl in PLAYERS)(
    waiting[pl] = (last_finish[pl] - first_start[pl]) - playtime[pl]
  );

solve minimize total_waiting;

output
  ["Total waiting time = ", show(total_waiting), "\n",
   "--- Piece schedule ---\n"] ++
  [ "Piece " ++ show(p) ++ ": start = " ++ show(start[p]) ++
    ", end = " ++ show(finish[p]) ++ "\n" | p in PIECES ] ++
  ["--- Player waiting ---\n"] ++
  [ "Player " ++ show(pl) ++ ": waiting = " ++ show(waiting[pl]) ++ "\n"
    | pl in PLAYERS ];