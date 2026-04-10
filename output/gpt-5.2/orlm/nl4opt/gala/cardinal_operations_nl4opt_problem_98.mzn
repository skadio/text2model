% Accident evacuation planning: choose helicopter and bus trips to minimize total time

% --- Data (embedded) ---
int: heli_capacity = 5;
int: heli_time = 1;

int: bus_capacity  = 8;
int: bus_time  = 3;

int: min_patients = 120;
int: max_bus_trips = 10;

% At least 30% of trips are by helicopter:
% heli_trips / (heli_trips + bus_trips) >= 0.30
% <=> 10*heli_trips >= 3*(heli_trips + bus_trips)
% <=> 7*heli_trips >= 3*bus_trips
int: heli_ratio_num = 7;
int: bus_ratio_num  = 3;

% --- Decision variables ---
% Upper bound: if all by helicopter, 24 trips suffice (24*5=120).
% Add slack; also ratio with up to 10 bus trips suggests <= 5 bus implies low heli; safe bound 100.
var 0..100: h;                 % number of helicopter trips
var 0..max_bus_trips: b;        % number of bus trips

% --- Constraints ---
constraint heli_capacity * h + bus_capacity * b >= min_patients;

% At least 30% of all trips are helicopter trips
constraint heli_ratio_num * h >= bus_ratio_num * b;

% (Optional, but sensible) If any trips are made, ratio is enforced already; allow 0 only if it meets patients.
% No extra constraint needed.

% --- Objective: minimize total time ---
var int: total_time = heli_time * h + bus_time * b;

solve minimize total_time;

output [
  "Helicopter trips = ", show(h), "\n",
  "Bus trips        = ", show(b), "\n",
  "Patients carried = ", show(heli_capacity*h + bus_capacity*b), "\n",
  "Total time (h)   = ", show(total_time), "\n"
];