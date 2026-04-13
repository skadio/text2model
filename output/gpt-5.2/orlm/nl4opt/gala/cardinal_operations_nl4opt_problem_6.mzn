include "globals.mzn";

% Data (embedded from problem statement)
int: bikeMeals = 8;
int: bikeCharge = 3;
int: scooterMeals = 5;
int: scooterCharge = 2;

int: totalCharge = 200;
int: minScooters = 20;
float: maxBikeFrac = 0.30;

% Upper bound on total number of vehicles used (using minimum charge per vehicle)
int: maxVehicles = totalCharge div min(bikeCharge, scooterCharge); % 200 div 2 = 100

% Decision: type of each potential vehicle slot (1=bike, 2=scooter)
array[1..maxVehicles] of var 1..2: veh;

% Counts of each type
var 0..maxVehicles: nbikes;
var 0..maxVehicles: nscooters;

constraint count(veh, 1, nbikes);
constraint count(veh, 2, nscooters);

% Resource constraint: total charge available
constraint nbikes * bikeCharge + nscooters * scooterCharge <= totalCharge;

% Policy constraints
constraint nscooters >= minScooters;
% At most 30% of vehicles are bikes: nbikes <= 0.3*(nbikes+nscooters)
constraint 10 * nbikes <= 3 * (nbikes + nscooters);

% Objective: maximize meals delivered
var int: totalMeals = nbikes * bikeMeals + nscooters * scooterMeals;

solve maximize totalMeals;

output [
  "nbikes = ", show(nbikes), "\n",
  "nscooters = ", show(nscooters), "\n",
  "totalVehicles = ", show(nbikes + nscooters), "\n",
  "totalChargeUsed = ", show(nbikes * bikeCharge + nscooters * scooterCharge), "\n",
  "totalMeals = ", show(totalMeals), "\n"
];