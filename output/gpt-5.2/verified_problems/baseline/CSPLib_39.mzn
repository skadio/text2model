int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;

/* rehearsal[p, i] = 1 if player p plays in piece i, else 0 */
array[1..num_players, 1..num_pieces] of int: rehearsal;

set of int: PIECES = 1..num_pieces;
set of int: PLAYERS = 1..num_players;

array[PIECES] of var PIECES: order;
constraint alldifferent(order);

array[1..num_pieces] of var int: start_time;
constraint start_time[1] = 0;
constraint forall(k in 2..num_pieces)(
  start_time[k] = start_time[k-1] + duration[order[k-1]]
);

var int: total_concert_time = sum(i in PIECES)(duration[i]);

/* first and last position (in the order) where player p plays */
array[PLAYERS] of var 1..num_pieces: first_pos;
array[PLAYERS] of var 1..num_pieces: last_pos;

constraint forall(p in PLAYERS)(
  exists(k in 1..num_pieces)(rehearsal[p, order[k]] = 1)
);

constraint forall(p in PLAYERS)(
  forall(k in 1..num_pieces)(
    (k < first_pos[p]) -> (rehearsal[p, order[k]] = 0)
  )
);
constraint forall(p in PLAYERS)(
  rehearsal[p, order[first_pos[p]]] = 1
);

constraint forall(p in PLAYERS)(
  forall(k in 1..num_pieces)(
    (k > last_pos[p]) -> (rehearsal[p, order[k]] = 0)
  )
);
constraint forall(p in PLAYERS)(
  rehearsal[p, order[last_pos[p]]] = 1
);

/* presence interval [arrival, departure) for each player */
array[PLAYERS] of var int: arrival;
array[PLAYERS] of var int: departure;

constraint forall(p in PLAYERS)(
  arrival[p] = start_time[first_pos[p]]
);

constraint forall(p in PLAYERS)(
  departure[p] = start_time[last_pos[p]] + duration[order[last_pos[p]]]
);

/* total playing time per player is fixed regardless of order */
array[PLAYERS] of int: play_time = [
  sum(i in PIECES)(rehearsal[p,i] * duration[i]) | p in PLAYERS
];

/* waiting time per player = time present - time playing */
array[PLAYERS] of var int: waiting_time;
constraint forall(p in PLAYERS)(
  waiting_time[p] = (departure[p] - arrival[p]) - play_time[p]
);

var int: total_waiting_time = sum(p in PLAYERS)(waiting_time[p]);

solve minimize total_waiting_time;

output [
  "total_waiting_time=", show(total_waiting_time), "\n",
  "order=", show([order[k] | k in 1..num_pieces]), "\n",
  "start_time=", show([start_time[k] | k in 1..num_pieces]), "\n",
  "waiting_time=", show([waiting_time[p] | p in PLAYERS]), "\n"
];