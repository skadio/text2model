% Parameters
int: heli_capacity = 5;
int: heli_time = 1;
int: bus_capacity = 8;
int: bus_time = 3;

int: min_patients = 120;
int: min_heli_pct_num = 3;   % 30% = 3/10
int: min_heli_pct_den = 10;
int: max_bus_trips = 10;

% Variables
var 0..max_bus_trips: b;                 % number of bus trips
var 0..(min_patients div heli_capacity + 200): h;  % number of helicopter trips (safe upper bound)

% Constraints
constraint
  heli_capacity * h + bus_capacity * b >= min_patients;

constraint
  min_heli_pct_den * h >= min_heli_pct_num * (h + b);  % h/(h+b) >= 0.3

% Objective
solve minimize heli_time * h + bus_time * b;