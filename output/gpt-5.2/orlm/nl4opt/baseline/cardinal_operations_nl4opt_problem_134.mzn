int: sedan_seats = 50;
int: bus_seats = 250;

int: sedan_pollution = 10;
int: bus_pollution = 40;

int: max_pollution = 800;
int: min_customers = 4600;

var 0..1000: sedans;
var 0..1000: buses;

constraint sedan_pollution * sedans + bus_pollution * buses <= max_pollution;
constraint sedan_seats * sedans + bus_seats * buses >= min_customers;

var int: total_vehicles = sedans + buses;

solve minimize total_vehicles;

output [
  "sedans=", show(sedans), "\n",
  "buses=", show(buses), "\n",
  "total_vehicles=", show(total_vehicles), "\n",
  "customers=", show(sedan_seats * sedans + bus_seats * buses), "\n",
  "pollution=", show(sedan_pollution * sedans + bus_pollution * buses), "\n"
];