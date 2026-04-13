% Transport patients by helicopter and bus to minimize total time.

int: heli_capacity = 5;
int: bus_capacity  = 8;

int: heli_time = 1; % hours per trip
int: bus_time  = 3; % hours per trip

int: min_patients = 120;
float: min_heli_share = 0.30;
int: max_bus_trips = 10;

var 0..1000: H; % helicopter trips
var 0..max_bus_trips: B; % bus trips

constraint heli_capacity * H + bus_capacity * B >= min_patients;

% At least 30% of trips are by helicopter: H / (H+B) >= 0.30
% Linearized: 10H >= 3(H+B)  -> 7H >= 3B
constraint 7 * H >= 3 * B;

% (Optional) Ensure there is at least one trip overall if desired.
constraint H + B >= 1;

var int: total_time = heli_time * H + bus_time * B;

solve minimize total_time;

output [
  "Helicopter trips = ", show(H), "\n",
  "Bus trips        = ", show(B), "\n",
  "Patients moved   = ", show(heli_capacity*H + bus_capacity*B), "\n",
  "Total time (h)   = ", show(total_time), "\n"
];