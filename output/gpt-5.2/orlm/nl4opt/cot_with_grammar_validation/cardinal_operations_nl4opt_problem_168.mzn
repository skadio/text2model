% Parameters
int: materials_per_basketball = 5;
int: hours_per_basketball = 1;
int: materials_per_football = 3;
int: hours_per_football = 2;

int: materials_available = 1500;
int: hours_available = 750;

int: min_footballs = 50;
int: basketballs_to_footballs_ratio = 3;

% Variables
var 0..(materials_available div materials_per_basketball): basketballs;
var min_footballs..(materials_available div materials_per_football): footballs;

% Constraints
constraint
  materials_per_basketball * basketballs + materials_per_football * footballs <= materials_available;

constraint
  hours_per_basketball * basketballs + hours_per_football * footballs <= hours_available;

constraint
  basketballs >= basketballs_to_footballs_ratio * footballs;

% Objective
solve maximize basketballs + footballs;