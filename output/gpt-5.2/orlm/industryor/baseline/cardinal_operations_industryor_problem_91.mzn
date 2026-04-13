% School trip transportation planning: minimize rental cost
% Data embedded in the model (no .dzn needed)

int: students = 400;

int: n_bus_available = 10;
int: n_minibus_available = 8;

int: seats_bus = 50;
int: seats_minibus = 40;

int: drivers_available = 9;

int: cost_bus = 800;       % £
int: cost_minibus = 600;   % £

var 0..n_bus_available: nbuses;
var 0..n_minibus_available: nminibuses;

constraint
  % Capacity must cover all students
  seats_bus * nbuses + seats_minibus * nminibuses >= students;

constraint
  % Each vehicle needs a driver
  nbuses + nminibuses <= drivers_available;

solve minimize cost_bus * nbuses + cost_minibus * nminibuses;

output [
  "Buses used: ", show(nbuses), "\n",
  "Minibuses used: ", show(nminibuses), "\n",
  "Total seats: ", show(seats_bus*nbuses + seats_minibus*nminibuses), "\n",
  "Drivers used: ", show(nbuses + nminibuses), "\n",
  "Total cost (£): ", show(cost_bus*nbuses + cost_minibus*nminibuses), "\n"
];