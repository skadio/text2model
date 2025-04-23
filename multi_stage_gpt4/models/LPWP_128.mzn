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
var LiquidSanitizers+1..TotalWater div WaterPerFoam: FoamSanitizers; % Number of foam hand sanitizers to produce

% Constraints

% Constraint to ensure that the total water used does not exceed the total available water
constraint LiquidSanitizers*WaterPerLiquid + FoamSanitizers*WaterPerFoam <= TotalWater;

% Constraint to ensure that the total alcohol used does not exceed the total available alcohol
constraint LiquidSanitizers*AlcoholPerLiquid + FoamSanitizers*AlcoholPerFoam <= TotalAlcohol;

% Constraint to ensure that more foam sanitizers are produced than liquid sanitizers
constraint FoamSanitizers > LiquidSanitizers;

% Constraint to limit the number of liquid sanitizers produced
constraint LiquidSanitizers <= MaxLiquid;

% Objective
solve maximize LiquidSanitizers*HandsPerLiquid + FoamSanitizers*HandsPerFoam;