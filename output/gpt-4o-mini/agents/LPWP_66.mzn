int: ButterPerAlmond;          % Butter required per almond croissant
int: ButterPerPistachio;       % Butter required per pistachio croissant
int: FlourPerAlmond;           % Flour required per almond croissant
int: FlourPerPistachio;        % Flour required per pistachio croissant
int: TotalButter;               % Total available butter
int: TotalFlour;                % Total available flour
int: TimePerAlmond;            % Time required per almond croissant
int: TimePerPistachio;         % Time required per pistachio croissant
int: MinAlmondRatio;            % Minimum almond-to-pistachio croissant production ratio

var 0..TotalButter div ButterPerAlmond: AlmondCroissants;   % Number of almond croissants to be produced
var 0..TotalButter div ButterPerPistachio: PistachioCroissants; % Number of pistachio croissants to be produced

% Constraints
constraint (AlmondCroissants >= MinAlmondRatio * PistachioCroissants); % Almond production ratio constraint
constraint (ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter); % Butter constraint
constraint (FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour); % Flour constraint

% Objective: Minimize total baking time
var int: totalBakingTime = TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;

solve minimize totalBakingTime;

output [ "Almond Croissants = ", show(AlmondCroissants), "\nPistachio Croissants = ", show(PistachioCroissants), "\nTotal Baking Time = ", show(totalBakingTime), "\n" ];