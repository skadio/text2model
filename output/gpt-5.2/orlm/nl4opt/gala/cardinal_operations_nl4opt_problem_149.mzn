% Office desk purchasing optimization (all data embedded)

% Data
int: budget = 2000;
int: max_space = 200;

int: cost_long = 300;
int: space_long = 10;
int: seats_long = 6;

int: cost_short = 100;
int: space_short = 4;
int: seats_short = 2;

% Decision variables: number of desks (nonnegative integers)
var 0..(budget div cost_long): long_desks;
var 0..(budget div cost_short): short_desks;

% Resource constraints
constraint cost_long * long_desks + cost_short * short_desks <= budget;
constraint space_long * long_desks + space_short * short_desks <= max_space;

% Objective: maximize total seats
var int: total_seats = seats_long * long_desks + seats_short * short_desks;

solve maximize total_seats;

output [
  "Long desks  = ", show(long_desks), "\n",
  "Short desks = ", show(short_desks), "\n",
  "Total seats = ", show(total_seats), "\n",
  "Total cost  = ", show(cost_long * long_desks + cost_short * short_desks), "\n",
  "Total space = ", show(space_long * long_desks + space_short * short_desks), "\n"
];