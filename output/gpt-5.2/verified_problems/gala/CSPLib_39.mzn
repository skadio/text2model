include "globals.mzn";

int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal; % 1 if player p plays piece j, else 0

% Decision: order[pos] = which piece is rehearsed at position pos
array[1..num_pieces] of var 1..num_pieces: order;
constraint all_different(order);

% Start time of each position in the rehearsal sequence
array[1..num_pieces] of var 0..sum(duration): start_pos;
constraint start_pos[1] = 0;
constraint forall(pos in 2..num_pieces)(
  start_pos[pos] = start_pos[pos-1] + duration[order[pos-1]]
);

% For each player: first and last position where they play
array[1..num_players] of var 1..num_pieces: firstPos;
array[1..num_players] of var 1..num_pieces: lastPos;

constraint forall(p in 1..num_players)(
  exists(pos in 1..num_pieces)(rehearsal[p, order[pos]] = 1)
);

constraint forall(p in 1..num_players)(
  forall(pos in 1..num_pieces)(
    (rehearsal[p, order[pos]] = 1) -> (firstPos[p] <= pos /\ lastPos[p] >= pos)
  )
);

constraint forall(p in 1..num_players)(
  rehearsal[p, order[firstPos[p]]] = 1 /\ rehearsal[p, order[lastPos[p]]] = 1
);

% Total time player p is present: from start of first piece they play to end of last piece they play
array[1..num_players] of var 0..sum(duration): presentTime;
constraint forall(p in 1..num_players)(
  presentTime[p] = (start_pos[lastPos[p]] + duration[order[lastPos[p]]]) - start_pos[firstPos[p]]
);

% Total time player p is actually playing
array[1..num_players] of var 0..sum(duration): playTime;
constraint forall(p in 1..num_players)(
  playTime[p] = sum(pos in 1..num_pieces)(
    rehearsal[p, order[pos]] * duration[order[pos]]
  )
);

% Waiting time is presence minus playing time
array[1..num_players] of var 0..sum(duration): waitTime;
constraint forall(p in 1..num_players)(
  waitTime[p] = presentTime[p] - playTime[p]
);

var 0..num_players * sum(duration): totalWaiting;
constraint totalWaiting = sum(p in 1..num_players)(waitTime[p]);

solve minimize totalWaiting;

output [
  "Minimum total waiting time = ", show(totalWaiting), "\n",
  "Order (positions -> piece) = ", show(order), "\n",
  "Start times per position   = ", show(start_pos), "\n",
  "First positions per player = ", show(firstPos), "\n",
  "Last positions per player  = ", show(lastPos), "\n",
  "Waiting times per player   = ", show(waitTime), "\n"
];