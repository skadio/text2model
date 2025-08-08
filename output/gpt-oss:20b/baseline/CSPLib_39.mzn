int: num_pieces;
int: num_players;
array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal;

array[1..num_pieces] of var 1..num_pieces: order;
constraint alldifferent(order);
constraint sum(order) = sum(i in 1..num_pieces) i;

array[0..num_pieces] of var int: cum;
constraint cum[0] = 0;
constraint forall(i in 1..num_pieces) (
    cum[i] = cum[i-1] + duration[order[i]]
);

array[1..num_pieces] of var int: start_time;
constraint forall(i in 1..num_pieces) (
    start_time[order[i]] = cum[i-1]
);

array[1..num_players] of var int: first_start_time;
array[1..num_players] of var int: last_end_time;
constraint forall(p in 1..num_players) (
    first_start_time[p] = min( [ start_time[i] | i in 1..num_pieces where rehearsal[p][i] == 1 ] )
);
constraint forall(p in 1..num_players) (
    last_end_time[p] = max( [ start_time[i] + duration[i] | i in 1..num_pieces where rehearsal[p][i] == 1 ] )
);

array[1..num_players] of var int: waiting_time;
constraint forall(p in 1..num_players) (
    waiting_time[p] = (last_end_time[p] - first_start_time[p]) - sum(i in 1..num_pieces where rehearsal[p][i] == 1) duration[i]
);

var int: total_waiting_time;
constraint total_waiting_time = sum(p in 1..num_players) waiting_time[p];

solve minimize total_waiting_time;

output [
    "Total waiting time: ", show(total_waiting_time), "\n",
    "Order: ", show(order), "\n"
];