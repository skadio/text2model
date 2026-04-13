% Parameters (with values embedded)
int: material_available = 1500;
int: hours_available = 750;

int: mat_basketball = 5;
int: hrs_basketball = 1;

int: mat_football = 3;
int: hrs_football = 2;

int: min_footballs = 50;

% Variables
var 0..material_available: basketballs;
var 0..material_available: footballs;

% Constraints
constraint mat_basketball * basketballs + mat_football * footballs <= material_available;
constraint hrs_basketball * basketballs + hrs_football * footballs <= hours_available;

constraint basketballs >= 3 * footballs;
constraint footballs >= min_footballs;

% Objective
solve maximize basketballs + footballs;