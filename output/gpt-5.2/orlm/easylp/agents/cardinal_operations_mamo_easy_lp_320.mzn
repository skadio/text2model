% Parameters
% Cost per vehicle on each route (in dollars)
int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Fleet availability (maximum total vehicles)
int: maxVehicles = 1000;

% Minimum vehicle requirements per route
int: minX = 200;
int: minY = 150;
int: minZ = 300;

% Variables
% Number of vehicles allocated to each route (whole vehicles)
var 0..maxVehicles: vehiclesX;
var 0..maxVehicles: vehiclesY;
var 0..maxVehicles: vehiclesZ;

% Total cost (in dollars)
var int: totalCost;

% Constraints
% Minimum vehicle requirements per route
constraint vehiclesX >= minX;
constraint vehiclesY >= minY;
constraint vehiclesZ >= minZ;

% Upper bounds per route (cannot exceed total fleet)
constraint vehiclesX <= maxVehicles;
constraint vehiclesY <= maxVehicles;
constraint vehiclesZ <= maxVehicles;

% Fleet size limit across all routes
constraint vehiclesX + vehiclesY + vehiclesZ <= maxVehicles;

% Total cost calculation based on per-route costs and allocated vehicles
constraint totalCost = costX * vehiclesX + costY * vehiclesY + costZ * vehiclesZ;

% Objective
solve minimize totalCost;

output [
  "vehiclesX=", show(vehiclesX), "\n",
  "vehiclesY=", show(vehiclesY), "\n",
  "vehiclesZ=", show(vehiclesZ), "\n",
  "totalCost=", show(totalCost), "\n"
];