int: WaterPerLiquid;
int: AlcoholPerLiquid;
int: WaterPerFoam;
int: AlcoholPerFoam;
int: TotalWater;
int: TotalAlcohol;
int: HandsPerLiquid;
int: HandsPerFoam;
int: MaxLiquid;

var 0..MaxLiquid: LiquidSanitizers;
var 0..max(TotalWater div max(1,WaterPerFoam), TotalAlcohol div max(1,AlcoholPerFoam)): FoamSanitizers;

constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

constraint FoamSanitizers >= LiquidSanitizers + 1;
constraint LiquidSanitizers <= MaxLiquid;

var int: TotalHands = HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;

solve maximize TotalHands;

output [
  "LiquidSanitizers=", show(LiquidSanitizers), "\n",
  "FoamSanitizers=", show(FoamSanitizers), "\n",
  "TotalHands=", show(TotalHands), "\n"
];