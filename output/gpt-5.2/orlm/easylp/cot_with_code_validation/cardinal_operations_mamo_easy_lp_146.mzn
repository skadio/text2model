% Parameters
int: maxTanks = 20;
int: maxAircrafts = 15;

int: minStrength = 10;          % 3*Tanks + 2*Aircrafts >= 10
int: maxOtherConstraint = 30;   % 4*Tanks + 1*Aircrafts <= 30

int: tankStrengthCoeff = 3;
int: aircraftStrengthCoeff = 2;

int: tankOtherCoeff = 4;
int: aircraftOtherCoeff = 1;

int: tankSupport = 5;
int: aircraftSupport = 7;

% Variables
var 0..maxTanks: Tanks;
var 0..maxAircrafts: Aircrafts;

var 0..(tankSupport*maxTanks + aircraftSupport*maxAircrafts): TotalSupport;

% Constraints
constraint tankStrengthCoeff * Tanks + aircraftStrengthCoeff * Aircrafts >= minStrength;
constraint tankOtherCoeff * Tanks + aircraftOtherCoeff * Aircrafts <= maxOtherConstraint;

constraint TotalSupport = tankSupport * Tanks + aircraftSupport * Aircrafts;

% Objective
solve minimize TotalSupport;