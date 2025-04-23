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
var 0..TotalButter div ButterPerAlmond: AlmondCroissants; % Number of almond croissants to be produced
var 0..TotalButter div ButterPerPistachio: PistachioCroissants; % Number of pistachio croissants to be produced

% Constraints

% Constraint to ensure that the total butter used does not exceed the total available butter
constraint AlmondCroissants*ButterPerAlmond + PistachioCroissants*ButterPerPistachio <= TotalButter;

% Constraint to ensure that the total flour used does not exceed the total available flour
constraint AlmondCroissants*FlourPerAlmond + PistachioCroissants*FlourPerPistachio <= TotalFlour;

% Constraint to ensure that the production of almond croissants is at least a fixed multiple of the pistachio croissant production
constraint AlmondCroissants >= MinAlmondRatio*PistachioCroissants;

% Objective
solve minimize AlmondCroissants*TimePerAlmond + PistachioCroissants*TimePerPistachio;