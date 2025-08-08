% Include global libraries if needed
include "globals.mzn";

% Input parameters (supplied in .dzn file)
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
% To give an upper bound for foam sanitizers, we use TotalWater as a loose bound.
var 0..TotalWater: FoamSanitizers;

% Constraints

% 1. More foam sanitizers than liquid sanitizers
constraint FoamSanitizers >= LiquidSanitizers + 1;

% 2. Limit the number of liquid sanitizers produced
constraint LiquidSanitizers <= MaxLiquid;

% 3. Water resource constraint
constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;

% 4. Alcohol resource constraint
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% Objective: maximize the number of hands cleaned by sanitizers
var int: TotalHandsCleaned = HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;
solve maximize TotalHandsCleaned;

% Output the production plan and the achieved cleaning capacity
output [
    "Liquid Sanitizers produced: ", show(LiquidSanitizers), "\n",
    "Foam Sanitizers produced: ", show(FoamSanitizers), "\n",
    "Total Hands Cleaned: ", show(TotalHandsCleaned), "\n"
];