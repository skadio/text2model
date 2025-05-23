include "globals.mzn";

% Parameters
int: num_pieces;
int: num_players;
array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal;

% Variables
array[1..num_pieces] of var 1..num_pieces: order; % order of pieces
array[1..num_players, 1..num_pieces] of var 0..sum(duration): arrival; % arrival time of each player for each piece
array[1..num_players, 1..num_pieces] of var 0..sum(duration): departure; % departure time of each player for each piece

% Constraints
constraint alldifferent(order);

% Each player arrives before or at the start of their first piece and leaves after their last piece
constraint forall(i in 1..num_players)(
  arrival[i, min([order[j] | j in 1..num_pieces where rehearsal[i,j] = 1])] = 0 /\ 
  departure[i, max([order[j] | j in 1..num_pieces where rehearsal[i,j] = 1])] = sum(duration)
);

% The arrival and departure times for each piece are consistent with the order and duration of the pieces
constraint forall(i in 1..num_players, j in 1..num_pieces)(
  if rehearsal[i,j] = 1 then
    arrival[i,order[j]] = sum([duration[k] | k in 1..order[j]-1]) /\
    departure[i,order[j]] = arrival[i,order[j]] + duration[j]
  else
    arrival[i,j] = departure[i,j] = 0
  endif
);

% Objective
var int: total_waiting_time = sum(i in 1..num_players, j in 1..num_pieces)(departure[i,j] - arrival[i,j] - duration[j]);
solve minimize total_waiting_time;

% Output
output ["Order: " ++ show(order) ++ "\nTotal waiting time: " ++ show(total_waiting_time)];