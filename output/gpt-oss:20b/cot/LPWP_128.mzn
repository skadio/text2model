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

int: MaxFoamWater = TotalWater div WaterPerFoam;
int: MaxFoamAlcohol = TotalAlcohol div AlcoholPerFoam;
int: MaxFoam = min(MaxFoamWater, MaxFoamAlcohol);

% Variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..MaxFoam: FoamSanitizers;

% Constraints
constraint FoamSanitizers > LiquidSanitizers;
constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% Objective
solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;