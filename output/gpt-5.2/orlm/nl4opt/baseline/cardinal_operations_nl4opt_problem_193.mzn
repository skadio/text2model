% Field trip bus hiring optimization

int: cap_small = 20;
int: cap_large = 50;
int: students_needed = 500;

% Decision variables
var 0..1000: small_buses;
var 0..1000: large_buses;

% At least 500 students transported
constraint cap_small * small_buses + cap_large * large_buses >= students_needed;

% At most 20% of buses can be large:
% large_buses / (small_buses + large_buses) <= 0.2
% Equivalent linear form: 5*large_buses <= small_buses + large_buses
constraint 5 * large_buses <= small_buses + large_buses;

% Objective: minimize total buses
var 0..2000: total_buses = small_buses + large_buses;
solve minimize total_buses;

output [
  "small_buses = ", show(small_buses), "\n",
  "large_buses = ", show(large_buses), "\n",
  "total_buses = ", show(total_buses), "\n",
  "capacity = ", show(cap_small * small_buses + cap_large * large_buses), "\n"
];