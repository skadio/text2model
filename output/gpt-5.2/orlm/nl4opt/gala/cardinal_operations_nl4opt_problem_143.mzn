include "globals.mzn";

% Data (embedded as requested)
int: demand = 1500;          % units of goods to deliver
int: cap_camel = 50;         % units per camel caravan trip
int: cap_truck = 150;        % units per desert truck trip
int: time_camel = 12;        % hours per camel caravan trip
int: time_truck = 5;         % hours per desert truck trip

% Decision variables: number of trips organized by each method
% Upper bounds chosen from worst-case all-camel / all-truck solutions.
var 0..(demand div cap_camel): camels;
var 0..(demand div cap_truck): trucks;

% Must deliver at least the required demand
constraint cap_camel * camels + cap_truck * trucks >= demand;

% Prefer more camel caravans than desert trucks (strictly more)
constraint camels > trucks;

% Objective: minimize total hours
var 0..100000: total_hours = time_camel * camels + time_truck * trucks;

solve minimize total_hours;

output [
  "Camels = ", show(camels), "\n",
  "Trucks = ", show(trucks), "\n",
  "Delivered = ", show(cap_camel * camels + cap_truck * trucks), "\n",
  "TotalHours = ", show(total_hours), "\n"
];