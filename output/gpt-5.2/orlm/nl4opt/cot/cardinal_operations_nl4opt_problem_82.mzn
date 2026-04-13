% Parameters (with values embedded)
int: orders_bike = 10;
int: energy_bike = 5;
int: tips_bike = 50;

int: orders_scooter = 7;
int: energy_scooter = 6;
int: tips_scooter = 43;

int: max_shifts = 40;
int: max_energy = 230;
int: min_orders = 320;
int: min_scooter_shifts = 5;

% Variables
var 0..max_shifts: bike_shifts;
var 0..max_shifts: scooter_shifts;

var 0..(orders_bike*max_shifts): total_orders;
var 0..max_energy: total_energy;
var 0..(tips_bike*max_shifts + tips_scooter*max_shifts): total_tips;

% Constraints
constraint bike_shifts + scooter_shifts <= max_shifts;
constraint scooter_shifts >= min_scooter_shifts;

constraint total_orders = orders_bike * bike_shifts + orders_scooter * scooter_shifts;
constraint total_energy = energy_bike * bike_shifts + energy_scooter * scooter_shifts;
constraint total_tips = tips_bike * bike_shifts + tips_scooter * scooter_shifts;

constraint total_orders >= min_orders;
constraint total_energy <= max_energy;

% Objective
solve maximize total_tips;

output [
  "bike_shifts=", show(bike_shifts), "\n",
  "scooter_shifts=", show(scooter_shifts), "\n",
  "total_orders=", show(total_orders), "\n",
  "total_energy=", show(total_energy), "\n",
  "total_tips=", show(total_tips), "\n"
];