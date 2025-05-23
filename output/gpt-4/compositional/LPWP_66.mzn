% Parameters
int: ButterPerAlmond; % Butter required per almond croissant
int: ButterPerPistachio; % Butter required per pistachio croissant
int: FlourPerAlmond; % Flour required per almond croissant
int: FlourPerPistachio; % Flour required per pistachio croissant
int: TotalButter; % Total available butter
int: TotalFlour; % Total available flour
int: TimePerAlmond; % Time required per almond croissant
int: TimePerPistachio; % Time required per pistachio croissant
float: MinAlmondRatio; % Minimum almond-to-pistachio croissant production ratio

% Variables
var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): AlmondCroissants; % Number of almond croissants to be produced
var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): PistachioCroissants; % Number of pistachio croissants to be produced

% Constraints

% Constraint: Total butter used should not exceed total available butter
constraint AlmondCroissants*ButterPerAlmond + PistachioCroissants*ButterPerPistachio <= TotalButter;

% Constraint: Total flour used should not exceed total available flour
constraint AlmondCroissants*FlourPerAlmond + PistachioCroissants*FlourPerPistachio <= TotalFlour;

% Constraint: Almond croissant production should be at least a fixed multiple of the pistachio croissant production
constraint AlmondCroissants >= MinAlmondRatio*PistachioCroissants;

% Objective
solve minimize AlmondCroissants*TimePerAlmond + PistachioCroissants*TimePerPistachio;