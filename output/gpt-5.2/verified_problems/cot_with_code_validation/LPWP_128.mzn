% Parameters
int: WaterPerLiquid;
int: AlcoholPerLiquid;
int: WaterPerFoam;
int: AlcoholPerFoam;
int: TotalWater;
int: TotalAlcohol;
int: HandsPerLiquid;
int: HandsPerFoam;
int: MaxLiquid;

% Decision variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..(TotalWater div max(1, WaterPerFoam)): FoamSanitizers;

% Constraints
constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;
constraint FoamSanitizers > LiquidSanitizers;

% Objective (maximize hands cleaned)
solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;

% Output
output [
  "LiquidSanitizers=", show(LiquidSanitizers), "\n",
  "FoamSanitizers=", show(FoamSanitizers), "\n",
  "TotalHandsCleaned=", show(HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers), "\n"
];