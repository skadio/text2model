% Tourism fleet planning: minimize total vehicles while meeting demand and pollution limits.

int: seat_sedan = 50;
int: poll_sedan = 10;

int: seat_bus = 250;
int: poll_bus = 40;

int: max_pollution = 800;
int: min_customers = 4600;

% Upper bounds from pollution limit
int: max_sedans = max_pollution div poll_sedan; % 80
int: max_buses  = max_pollution div poll_bus;   % 20

var 0..max_sedans: sedans;
var 0..max_buses: buses;

constraint poll_sedan * sedans + poll_bus * buses <= max_pollution;
constraint seat_sedan * sedans + seat_bus * buses >= min_customers;

var 0..(max_sedans + max_buses): total_vehicles = sedans + buses;

solve minimize total_vehicles;

output [
  "Sedans = ", show(sedans), "\n",
  "Buses = ", show(buses), "\n",
  "TotalVehicles = ", show(total_vehicles), "\n",
  "CustomersPerDay = ", show(seat_sedan * sedans + seat_bus * buses), "\n",
  "PollutionPerDay = ", show(poll_sedan * sedans + poll_bus * buses), "\n"
];