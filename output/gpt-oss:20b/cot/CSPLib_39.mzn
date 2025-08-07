% Parameters
int: num_pieces;
int: num_players;
array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal;

% Derived parameter
int: sumDur = sum(duration);

% Variables
array[1..num_pieces] of var 1..num_pieces: order;
array[1..num_pieces] of var 1..num_pieces: pos;
array[1..num_pieces] of var 0..sumDur: start_time;
array[1..num_players] of var 0..sumDur: waiting;
var 0..num_players*sumDur: total_waiting;

% Constraints
constraint
    alldifferent(order);

constraint
    forall(i in 1..num_pieces) (
        order[pos[i]] = i
    );

constraint
    forall(i in 1..num_pieces) (
        start_time[i] = sum(j in 1..num_pieces where j < pos[i]) duration[order[j]]
    );

constraint
    forall(p in 1..num_players) (
        waiting[p] = 
            max(i in 1..num_pieces where rehearsal[p,i] = 1) (start_time[i] + duration[i]) -
            min(i in 1..num_pieces where rehearsal[p,i] = 1) start_time[i] -
            sum(i in 1..num_pieces where rehearsal[p,i] = 1) duration[i]
    );

constraint
    total_waiting = sum(p in 1..num_players) waiting[p];

% Objective
solve minimize total_waiting;