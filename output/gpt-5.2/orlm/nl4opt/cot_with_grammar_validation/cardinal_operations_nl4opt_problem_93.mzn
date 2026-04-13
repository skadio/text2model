% Parameters
int: posters_per_circular = 4;
int: participants_per_circular = 5;
int: guests_per_circular = 8;
int: space_per_circular = 15;

int: posters_per_rectangular = 4;
int: participants_per_rectangular = 4;
int: guests_per_rectangular = 12;
int: space_per_rectangular = 20;

int: min_participants = 500;
int: min_posters = 300;
int: max_space = 1900;

% Variables
var 0..(max_space div space_per_circular): circular_tables;
var 0..(max_space div space_per_rectangular): rectangular_tables;

var 0..(max_space div min(space_per_circular, space_per_rectangular)) * max(guests_per_circular, guests_per_rectangular): total_guests;

% Constraints
constraint
  space_per_circular * circular_tables + space_per_rectangular * rectangular_tables <= max_space;

constraint
  participants_per_circular * circular_tables + participants_per_rectangular * rectangular_tables >= min_participants;

constraint
  posters_per_circular * circular_tables + posters_per_rectangular * rectangular_tables >= min_posters;

constraint
  total_guests = guests_per_circular * circular_tables + guests_per_rectangular * rectangular_tables;

% Objective
solve maximize total_guests;