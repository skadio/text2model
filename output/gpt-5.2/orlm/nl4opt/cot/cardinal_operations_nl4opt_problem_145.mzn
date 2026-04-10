% Parameters (with values embedded)
int: minA = 80;
int: minC = 100;

int: A_crab = 5;
int: C_crab = 7;
int: F_crab = 4;

int: A_lob = 8;
int: C_lob = 4;
int: F_lob = 6;

% Variables
var 0..1000: crab;
var 0..1000: lobster;

% Constraints
constraint A_crab * crab + A_lob * lobster >= minA;
constraint C_crab * crab + C_lob * lobster >= minC;

% At most 40% lobster rolls: lobster <= 0.4*(crab + lobster) -> 3*lobster <= 2*crab
constraint 3 * lobster <= 2 * crab;

% Objective
solve minimize F_crab * crab + F_lob * lobster;