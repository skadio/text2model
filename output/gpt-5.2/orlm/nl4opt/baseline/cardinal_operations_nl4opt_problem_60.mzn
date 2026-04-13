% Ski lift planning - minimize total number of lifts

int: cap_dense = 45;      % guests per minute
int: cap_loose = 20;      % guests per minute
int: elec_dense = 30;     % electricity units
int: elec_loose = 22;     % electricity units

int: min_loose = 5;
int: min_guests = 1000;
int: max_elec = 940;

var 0..1000: dense;
var 0..1000: loose;

constraint loose >= min_loose;
constraint cap_dense * dense + cap_loose * loose >= min_guests;
constraint elec_dense * dense + elec_loose * loose <= max_elec;

var 0..2000: total_lifts = dense + loose;

solve minimize total_lifts;

output [
  "dense=", show(dense), "\n",
  "loose=", show(loose), "\n",
  "total_lifts=", show(total_lifts), "\n",
  "guests_per_min=", show(cap_dense * dense + cap_loose * loose), "\n",
  "electricity_used=", show(elec_dense * dense + elec_loose * loose), "\n"
];