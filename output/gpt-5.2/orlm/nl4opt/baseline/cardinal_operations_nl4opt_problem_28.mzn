int: DogCapability = 100;
int: TruckCapability = 300;
int: DogCost = 50;
int: TruckCost = 100;
int: MaxBudget = 1000;

var 0..MaxBudget div DogCost: dogTrips;
var 0..MaxBudget div TruckCost: truckTrips;

constraint DogCost * dogTrips + TruckCost * truckTrips <= MaxBudget;
constraint dogTrips < truckTrips;

var int: totalFish = DogCapability * dogTrips + TruckCapability * truckTrips;

solve maximize totalFish;

output [
  "dogTrips=", show(dogTrips), "\n",
  "truckTrips=", show(truckTrips), "\n",
  "totalFish=", show(totalFish), "\n",
  "totalCost=", show(DogCost*dogTrips + TruckCost*truckTrips), "\n"
];