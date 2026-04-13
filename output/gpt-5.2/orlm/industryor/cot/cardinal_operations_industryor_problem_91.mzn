% Parameters (with values embedded)
int: students = 400;

int: max_buses = 10;
int: max_minibuses = 8;

int: seats_bus = 50;
int: seats_minibus = 40;

int: drivers_available = 9;

int: cost_bus = 800;
int: cost_minibus = 600;

% Variables
var 0..max_buses: buses_used;
var 0..max_minibuses: minibuses_used;

% Constraints
constraint buses_used + minibuses_used <= drivers_available;
constraint seats_bus * buses_used + seats_minibus * minibuses_used >= students;

% Objective
solve minimize cost_bus * buses_used + cost_minibus * minibuses_used;