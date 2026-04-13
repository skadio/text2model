% Parameters
int: AlmondCroissants;            % (input nomenclature) Upper bound / reference for almond croissants
int: PistachioCroissants;         % (input nomenclature) Upper bound / reference for pistachio croissants

int: ButterPerAlmond;             % Butter required per almond croissant
int: ButterPerPistachio;          % Butter required per pistachio croissant
int: FlourPerAlmond;              % Flour required per almond croissant
int: FlourPerPistachio;           % Flour required per pistachio croissant

int: TotalButter;                 % Total available butter
int: TotalFlour;                  % Total available flour

int: TimePerAlmond;               % Time required per almond croissant
int: TimePerPistachio;            % Time required per pistachio croissant

int: MinAlmondRatio;              % Minimum almond-to-pistachio production ratio

% Variables
var 0..AlmondCroissants: numAlmond;        % Decision variable: number of almond croissants produced
var 0..PistachioCroissants: numPistachio;  % Decision variable: number of pistachio croissants produced

var 0..TotalButter: butterUsed;            % Total butter used by the production plan
var 0..TotalFlour: flourUsed;              % Total flour used by the production plan

var 0..(TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants): totalBakingTime;
                                          % Total baking time for the production plan

% Constraints

% --- Ingredient accounting constraints (define resource usage from decisions) ---
constraint butterUsed = ButterPerAlmond * numAlmond + ButterPerPistachio * numPistachio;
constraint flourUsed  = FlourPerAlmond  * numAlmond + FlourPerPistachio  * numPistachio;

% --- Ingredient capacity constraints (cannot exceed available ingredients) ---
constraint butterUsed <= TotalButter;
constraint flourUsed  <= TotalFlour;

% --- Popularity / minimum production ratio constraint ---
% Ensure almond production is at least MinAlmondRatio times pistachio production.
constraint numAlmond >= MinAlmondRatio * numPistachio;

% --- Baking time accounting constraint (define total time from decisions) ---
constraint totalBakingTime = TimePerAlmond * numAlmond + TimePerPistachio * numPistachio;

% Objective
solve minimize totalBakingTime;