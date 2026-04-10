% Parameters
int: totalVehicles = 1000;          % Total vehicles available
int: minVehiclesX  = 200;           % Minimum vehicles required on route X
int: minVehiclesY  = 150;           % Minimum vehicles required on route Y
int: minVehiclesZ  = 300;           % Minimum vehicles required on route Z

int: costPerVehicleX = 5;           % Cost per vehicle on route X ($)
int: costPerVehicleY = 4;           % Cost per vehicle on route Y ($)
int: costPerVehicleZ = 6;           % Cost per vehicle on route Z ($)

% Variables
var minVehiclesX..totalVehicles: vehiclesX;   % Vehicles allocated to route X
var minVehiclesY..totalVehicles: vehiclesY;   % Vehicles allocated to route Y
var minVehiclesZ..totalVehicles: vehiclesZ;   % Vehicles allocated to route Z

% Upper bound is a safe worst-case total cost if all vehicles were assigned to each route
var 0..(costPerVehicleX*totalVehicles
      + costPerVehicleY*totalVehicles
      + costPerVehicleZ*totalVehicles): totalCost;  % Total allocation cost ($)

% Constraints
% Fleet availability constraint: total vehicles allocated cannot exceed fleet size
constraint
  vehiclesX + vehiclesY + vehiclesZ <= totalVehicles;

% Total cost definition based on per-route allocation costs
constraint
  totalCost =
    costPerVehicleX * vehiclesX +
    costPerVehicleY * vehiclesY +
    costPerVehicleZ * vehiclesZ;

% Objective
solve minimize totalCost;