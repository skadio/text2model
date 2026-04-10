% Food delivery shift planning: maximize tips

int: max_shifts = 40;
int: max_energy = 230;
int: min_orders = 320;
int: min_scooter_shifts = 5;

int: bike_orders = 10;
int: bike_energy = 5;
int: bike_tips = 50;

int: scooter_orders = 7;
int: scooter_energy = 6;
int: scooter_tips = 43;

var 0..max_shifts: bike_shifts;
var 0..max_shifts: scooter_shifts;

constraint bike_shifts + scooter_shifts <= max_shifts;
constraint bike_energy * bike_shifts + scooter_energy * scooter_shifts <= max_energy;
constraint bike_orders * bike_shifts + scooter_orders * scooter_shifts >= min_orders;
constraint scooter_shifts >= min_scooter_shifts;

var int: total_tips = bike_tips * bike_shifts + scooter_tips * scooter_shifts;

solve maximize total_tips;

output [
  "bike_shifts = ", show(bike_shifts), "\n",
  "scooter_shifts = ", show(scooter_shifts), "\n",
  "total_orders = ", show(bike_orders * bike_shifts + scooter_orders * scooter_shifts), "\n",
  "total_energy = ", show(bike_energy * bike_shifts + scooter_energy * scooter_shifts), "\n",
  "total_tips = ", show(total_tips), "\n"
];