% Body wash ingredient mix optimization (embedded data)

int: min_coconut = 300;
int: max_total = 550;

float: time_coconut = 0.7;
float: time_lavender = 0.9;

% Decision variables: units of each ingredient
var 0..max_total: coconut;
var 0..max_total: lavender;

% Constraints
constraint coconut >= min_coconut;
constraint coconut + lavender <= max_total;
constraint coconut <= 3 * lavender;

% Objective: minimize total time (one must be added before the other => times add)
var float: total_time = time_coconut * int2float(coconut) + time_lavender * int2float(lavender);
solve minimize total_time;

output [
  "coconut_units=", show(coconut), "\n",
  "lavender_units=", show(lavender), "\n",
  "total_time_minutes=", show(total_time), "\n"
];