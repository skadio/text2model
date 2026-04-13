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
var 0..max(0, max(TotalWater div WaterPerFoam, TotalAlcohol div AlcoholPerFoam)): FoamSanitizers;

constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;
constraint FoamSanitizers > LiquidSanitizers;
constraint LiquidSanitizers <= MaxLiquid;

solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;