% Parameters
int: ButterPerAlmond;        % butter required per almond croissant
int: ButterPerPistachio;     % butter required per pistachio croissant
int: FlourPerAlmond;         % flour required per almond croissant
int: FlourPerPistachio;      % flour required per pistachio croissant
int: TotalButter;            % total available butter
int: TotalFlour;             % total available flour
int: TimePerAlmond;          % baking time per almond croissant
int: TimePerPistachio;       % baking time per pistachio croissant
int: MinAlmondRatio;         % minimum required ratio: Almond >= MinAlmondRatio * Pistachio

% Variables
% Upper bounds derived from butter availability (safe, and avoids division by 0 via max(1, ...))
var 0..(TotalButter div max(1, ButterPerAlmond)): AlmondCroissants;       
var 0..(TotalButter div max(1, ButterPerPistachio)): PistachioCroissants;

% Helper variable for the minimized objective value
var 0..(
    TimePerAlmond * (TotalButter div max(1, ButterPerAlmond))
  + TimePerPistachio * (TotalButter div max(1, ButterPerPistachio))
): TotalBakingTime;

% Constraints
% Ingredient capacity constraints (do not exceed available resources)
constraint
  ButterPerAlmond * AlmondCroissants
+ ButterPerPistachio * PistachioCroissants
<= TotalButter;

constraint
  FlourPerAlmond * AlmondCroissants
+ FlourPerPistachio * PistachioCroissants
<= TotalFlour;

% Popularity / production ratio constraint (almond must be at least a multiple of pistachio)
constraint
  AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Define total baking time as the sum of per-item baking times
constraint
  TotalBakingTime =
    TimePerAlmond * AlmondCroissants
  + TimePerPistachio * PistachioCroissants;

% Objective
solve minimize TotalBakingTime;