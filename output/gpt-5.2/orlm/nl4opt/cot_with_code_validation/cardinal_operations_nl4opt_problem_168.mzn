% Parameters
int: mat_per_basketball = 5;
int: hrs_per_basketball = 1;
int: mat_per_football = 3;
int: hrs_per_football = 2;

int: total_materials = 1500;
int: total_hours = 750;

int: min_footballs = 50;
int: basketballs_per_football = 3;

% Variables
var 0..(total_materials div mat_per_basketball): basketballs;
var 0..(total_materials div mat_per_football): footballs;

% Constraints
constraint
  mat_per_basketball * basketballs + mat_per_football * footballs <= total_materials;

constraint
  hrs_per_basketball * basketballs + hrs_per_football * footballs <= total_hours;

constraint
  basketballs >= basketballs_per_football * footballs;

constraint
  footballs >= min_footballs;

% Objective
solve maximize basketballs + footballs;