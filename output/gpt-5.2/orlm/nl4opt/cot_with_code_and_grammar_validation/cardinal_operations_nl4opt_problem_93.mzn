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
int: total_space = 1900;

% Variables
var 0..(total_space div space_per_circular): num_circular;
var 0..(total_space div space_per_rectangular): num_rectangular;

var 0..(guests_per_rectangular * (total_space div space_per_rectangular)
      + guests_per_circular * (total_space div space_per_circular)): total_guests;

% Constraints
constraint
  space_per_circular * num_circular + space_per_rectangular * num_rectangular <= total_space;

constraint
  participants_per_circular * num_circular + participants_per_rectangular * num_rectangular >= min_participants;

constraint
  posters_per_circular * num_circular + posters_per_rectangular * num_rectangular >= min_posters;

constraint
  total_guests = guests_per_circular * num_circular + guests_per_rectangular * num_rectangular;

% Objective
solve maximize total_guests;