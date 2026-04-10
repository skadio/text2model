% Parameters (with values embedded)
int: maxTanks = 20;
int: maxAircrafts = 15;

int: minStrength = 10;          % 3*Tanks + 2*Aircrafts >= 10
int: maxLoad = 30;              % 4*Tanks + Aircrafts <= 30

int: supportTank = 5;
int: supportAircraft = 7;

% Variables
var 0..maxTanks: Tanks;
var 0..maxAircrafts: Aircrafts;

var int: TotalSupport;

% Constraints
constraint 3 * Tanks + 2 * Aircrafts >= minStrength;
constraint 4 * Tanks + Aircrafts <= maxLoad;

constraint TotalSupport = supportTank * Tanks + supportAircraft * Aircrafts;

% Objective
solve minimize TotalSupport;