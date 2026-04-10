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
var 0..TotalWater div min(1, WaterPerFoam): FoamSanitizers;

constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

constraint FoamSanitizers > LiquidSanitizers;

var int: TotalHandsCleaned = HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;

solve maximize TotalHandsCleaned;

output [
  "LiquidSanitizers=", show(LiquidSanitizers), "\n",
  "FoamSanitizers=", show(FoamSanitizers), "\n",
  "TotalHandsCleaned=", show(TotalHandsCleaned), "\n"
];