% Parameters
int: mat_per_basketball = 5;
int: time_per_basketball = 1;
int: mat_per_football = 3;
int: time_per_football = 2;

int: mat_available = 1500;
int: time_available = 750;

int: min_football = 50;
int: basketball_to_football_ratio = 3;

% Variables
var 0..(mat_available div mat_per_basketball): basketballs;
var 0..(mat_available div mat_per_football): footballs;

% Constraints
constraint
  mat_per_basketball * basketballs + mat_per_football * footballs <= mat_available;

constraint
  time_per_basketball * basketballs + time_per_football * footballs <= time_available;

constraint
  basketballs >= basketball_to_football_ratio * footballs;

constraint
  footballs >= min_football;

% Objective
solve maximize basketballs + footballs;