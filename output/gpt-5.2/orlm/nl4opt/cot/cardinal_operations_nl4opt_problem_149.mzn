% Parameters (with values embedded)
int: budget = 2000;
int: max_space = 200;

int: cost_long = 300;
int: space_long = 10;
int: seat_long = 6;

int: cost_short = 100;
int: space_short = 4;
int: seat_short = 2;

% Variables
var 0..(budget div cost_long): long_desks;
var 0..(budget div cost_short): short_desks;

% Constraints
constraint cost_long * long_desks + cost_short * short_desks <= budget;
constraint space_long * long_desks + space_short * short_desks <= max_space;

% Objective
var int: total_seats = seat_long * long_desks + seat_short * short_desks;
solve maximize total_seats;

output [
  "long_desks = ", show(long_desks), "\n",
  "short_desks = ", show(short_desks), "\n",
  "total_seats = ", show(total_seats), "\n"
];