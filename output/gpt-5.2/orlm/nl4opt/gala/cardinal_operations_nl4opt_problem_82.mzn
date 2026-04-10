% Food delivery shift planning (bike vs scooter)
% Maximize tips subject to shifts, energy, order requirements, and min scooters.

% Parameters (embedded from the problem statement)
int: totalShifts = 40;
int: energyAvail = 230;
int: minOrders   = 320;

int: bikeOrders   = 10;
int: bikeEnergy   = 5;
int: bikeTips     = 50;

int: scooterOrders = 7;
int: scooterEnergy = 6;
int: scooterTips   = 43;

int: minScooterShifts = 5;

% Decision variables
var 0..totalShifts: bikeShifts;
var 0..totalShifts: scooterShifts;

% Constraints
constraint bikeShifts + scooterShifts = totalShifts;
constraint bikeEnergy * bikeShifts + scooterEnergy * scooterShifts <= energyAvail;
constraint bikeOrders * bikeShifts + scooterOrders * scooterShifts >= minOrders;
constraint scooterShifts >= minScooterShifts;

% Objective: maximize tips
var int: totalTips = bikeTips * bikeShifts + scooterTips * scooterShifts;
solve maximize totalTips;

output [
  "bikeShifts = ", show(bikeShifts), "\n",
  "scooterShifts = ", show(scooterShifts), "\n",
  "totalOrders = ", show(bikeOrders * bikeShifts + scooterOrders * scooterShifts), "\n",
  "totalEnergy = ", show(bikeEnergy * bikeShifts + scooterEnergy * scooterShifts), "\n",
  "totalTips = ", show(totalTips), "\n"
];