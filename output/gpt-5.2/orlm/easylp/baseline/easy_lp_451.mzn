int: fert_min = 0;
int: fert_max = 100;
int: pest_min = 0;
int: pest_max = 60;

var fert_min..fert_max: Fertilizer;
var pest_min..pest_max: Pesticide;

constraint Fertilizer + Pesticide >= 50;
constraint 2 * Fertilizer + Pesticide <= 120;
constraint Fertilizer >= Pesticide + 10;

var int: TotalCost = 2 * Fertilizer + 3 * Pesticide;

solve minimize TotalCost;

output [
  "Fertilizer=", show(Fertilizer), "\n",
  "Pesticide=", show(Pesticide), "\n",
  "MinimumTotalCost=", show(TotalCost), "\n"
];