include "globals.mzn";

% Data (embedded as required)
int: maxTanks = 20;
int: maxAircraft = 15;

int: minStrength = 10;        % 3*T + 2*A >= 10
int: maxOther = 30;           % 4*T + A <= 30

int: supportPerTank = 5;
int: supportPerAircraft = 7;

% Decision variables (integers)
var 0..maxTanks: Tanks;
var 0..maxAircraft: Aircraft;

% Constraints
constraint 3 * Tanks + 2 * Aircraft >= minStrength;
constraint 4 * Tanks + Aircraft <= maxOther;

% Objective: minimize total support points
var int: totalSupport = supportPerTank * Tanks + supportPerAircraft * Aircraft;
solve minimize totalSupport;

output [
  "Tanks = ", show(Tanks), "\n",
  "Aircraft = ", show(Aircraft), "\n",
  "Minimum total support points (rounded) = ", show(totalSupport), "\n"
];