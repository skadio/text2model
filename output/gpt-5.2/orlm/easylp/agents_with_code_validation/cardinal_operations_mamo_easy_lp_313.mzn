% Parameters
int: totalResourceLimit = 1000;        % Maximum total resource points available
int: tankResource = 5;                % Resource points per Tank
int: aircraftResource = 3;            % Resource points per Aircraft
int: submarineResource = 2;           % Resource points per Submarine

int: minStrength = 200;               % Minimum required combined strength
int: tankStrengthCoeff = 2;           % Strength coefficient for Tanks
int: aircraftStrengthCoeff = 4;       % Strength coefficient for Aircrafts
int: submarineStrengthCoeff = 1;      % Strength coefficient for Submarines

int: diffTarget = 50;                 % Required exact difference: Tanks - (Aircrafts + Submarines)

int: tankCost = 30;                   % Cost per Tank (dollars)
int: aircraftCost = 20;               % Cost per Aircraft (dollars)
int: submarineCost = 10;              % Cost per Submarine (dollars)

% Variables
var 0..(totalResourceLimit div tankResource): tanks;           % Number of Tanks (nonnegative integer)
var 0..(totalResourceLimit div aircraftResource): aircrafts;   % Number of Aircrafts (nonnegative integer)
var 0..(totalResourceLimit div submarineResource): submarines; % Number of Submarines (nonnegative integer)

% Upper bound is a safe (loose) bound based on max possible unit counts within the resource limit
var 0..(tankCost*(totalResourceLimit div tankResource)
      + aircraftCost*(totalResourceLimit div aircraftResource)
      + submarineCost*(totalResourceLimit div submarineResource)): totalCost;

% Constraints
% --- Resource budget constraint (do not exceed total available resource points) ---
constraint
  tankResource * tanks
+ aircraftResource * aircrafts
+ submarineResource * submarines
<= totalResourceLimit;

% --- Minimum combined strength requirement ---
constraint
  tankStrengthCoeff * tanks
+ aircraftStrengthCoeff * aircrafts
+ submarineStrengthCoeff * submarines
>= minStrength;

% --- Exact difference constraint: Tanks - (Aircrafts + Submarines) == diffTarget ---
constraint
  tanks - (aircrafts + submarines) = diffTarget;

% --- Define total operational cost consistently with unit counts and unit costs ---
constraint
  totalCost =
    tankCost * tanks
  + aircraftCost * aircrafts
  + submarineCost * submarines;

% Objective
solve minimize totalCost;