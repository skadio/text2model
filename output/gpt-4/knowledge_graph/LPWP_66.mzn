% Parameters
int: ButterPerAlmond; % Butter required per almond croissant
int: ButterPerPistachio; % Butter required per pistachio croissant
int: FlourPerAlmond; % Flour required per almond croissant
int: FlourPerPistachio; % Flour required per pistachio croissant
int: TotalButter; % Total available butter
int: TotalFlour; % Total available flour
int: TimePerAlmond; % Time required per almond croissant
int: TimePerPistachio; % Time required per pistachio croissant
int: MinAlmondRatio; % Minimum almond-to-pistachio croissant production ratio

% Variables
var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): AlmondCroissants; % Number of almond croissants to be produced
var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): PistachioCroissants; % Number of pistachio croissants to be produced

% Constraints
constraint AlmondCroissants * ButterPerAlmond + PistachioCroissants * ButterPerPistachio <= TotalButter;
constraint AlmondCroissants * FlourPerAlmond + PistachioCroissants * FlourPerPistachio <= TotalFlour;
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve minimize AlmondCroissants * TimePerAlmond + PistachioCroissants * TimePerPistachio;

% Output
output ["Almond Croissants: ", show(AlmondCroissants), "\nPistachio Croissants: ", show(PistachioCroissants)];