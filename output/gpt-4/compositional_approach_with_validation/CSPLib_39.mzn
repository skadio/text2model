% Parameters
int: num_pieces; % Number of pieces of music for the concert
int: num_players; % Number of players in the orchestra
array[1..num_pieces] of int: duration; % Array containing the duration of each piece
array[1..num_players, 1..num_pieces] of 0..1: rehearsal; % Array representing players' availability for each piece

% Variables
array[1..num_pieces] of var 1..num_pieces: order; % Order in which the pieces will be rehearsed
array[1..num_players] of var 0..sum(duration): waiting_time; % Waiting time for each player
var int: total_waiting_time; % Total waiting time for all players

% Constraints

% Ensure that all pieces are rehearsed in a unique order
constraint alldifferent(order);

% Calculate the waiting time for each player
constraint forall(i in 1..num_players) (
  waiting_time[i] = sum(j in 1..num_pieces) (
    if j < min([k | k in 1..num_pieces where order[k] = min([order[l] | l in 1..num_pieces where rehearsal[i, l] = 1])]) 
    \/ j > max([k | k in 1..num_pieces where order[k] = max([order[l] | l in 1..num_pieces where rehearsal[i, l] = 1])]) 
    then 0 
    else duration[order[j]] 
    endif
  ) - sum(j in 1..num_pieces where rehearsal[i, j] = 1) (duration[j])
);

% Calculate the total waiting time for all players
constraint total_waiting_time = sum(waiting_time);

% Objective
solve minimize total_waiting_time;