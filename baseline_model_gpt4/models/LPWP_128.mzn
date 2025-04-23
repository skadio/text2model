% Parameters
int: LiquidSanitizers; % Number of liquid hand sanitizers to produce
int: FoamSanitizers; % Number of foam hand sanitizers to produce
int: WaterPerLiquid; % Water required per liquid sanitizer
int: AlcoholPerLiquid; % Alcohol required per liquid sanitizer
int: WaterPerFoam; % Water required per foam sanitizer
int: AlcoholPerFoam; % Alcohol required per foam sanitizer
int: TotalWater; % Total available water
int: TotalAlcohol; % Total available alcohol
int: HandsPerLiquid; % Cleaning capacity per liquid sanitizer
int: HandsPerFoam; % Cleaning capacity per foam sanitizer
int: MaxLiquid; % Maximum number of liquid sanitizers

% Variables
var 0..MaxLiquid: Liquid;
var Liquid+1..TotalWater div WaterPerFoam: Foam;

% Constraints
constraint Liquid * WaterPerLiquid + Foam * WaterPerFoam <= TotalWater;
constraint Liquid * AlcoholPerLiquid + Foam * AlcoholPerFoam <= TotalAlcohol;
constraint Foam > Liquid;

% Objective
var int: TotalHands = Liquid * HandsPerLiquid + Foam * HandsPerFoam;
solve maximize TotalHands;

% Output
output ["Liquid sanitizers: ", show(Liquid), "\n",
        "Foam sanitizers: ", show(Foam), "\n",
        "Total hands cleaned: ", show(TotalHands)];