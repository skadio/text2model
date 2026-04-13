% Parameters
int: maxTanks = 20;
int: maxAircrafts = 15;

int: minStrength = 10;              % 3*Tanks + 2*Aircrafts >= minStrength
int: maxSecondConstraint = 30;      % 4*Tanks + 1*Aircrafts <= maxSecondConstraint

int: supportPerTank = 5;
int: supportPerAircraft = 7;

% Variables
var 0..maxTanks: Tanks;
var 0..maxAircrafts: Aircrafts;
var 0..(supportPerTank*maxTanks + supportPerAircraft*maxAircrafts): TotalSupport;

% Constraints
constraint 3 * Tanks + 2 * Aircrafts >= minStrength;
constraint 4 * Tanks + Aircrafts <= maxSecondConstraint;

constraint TotalSupport = supportPerTank * Tanks + supportPerAircraft * Aircrafts;

% Objective
solve minimize TotalSupport;