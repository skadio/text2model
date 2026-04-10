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

% Variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..max(TotalWater div WaterPerFoam, TotalAlcohol div AlcoholPerFoam): FoamSanitizers;

% Constraints
constraint
  WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;

constraint
  AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

constraint
  FoamSanitizers > LiquidSanitizers;

constraint
  LiquidSanitizers <= MaxLiquid;

% Objective
solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;