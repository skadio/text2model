% Parameters
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
var 0..MaxLiquid: LiquidSanitizers; % Number of liquid hand sanitizers to produce
var 0..TotalWater div WaterPerFoam: FoamSanitizers; % Number of foam hand sanitizers to produce

% Constraints
constraint LiquidSanitizers * WaterPerLiquid + FoamSanitizers * WaterPerFoam <= TotalWater;
constraint LiquidSanitizers * AlcoholPerLiquid + FoamSanitizers * AlcoholPerFoam <= TotalAlcohol;
constraint FoamSanitizers > LiquidSanitizers;

% Objective
solve maximize LiquidSanitizers * HandsPerLiquid + FoamSanitizers * HandsPerFoam;