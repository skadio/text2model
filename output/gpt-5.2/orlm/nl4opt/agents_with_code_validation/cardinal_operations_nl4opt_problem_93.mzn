% Parameters
% Capacity/requirements per table type
int: participants_per_circular = 5;
int: participants_per_rectangular = 4;

int: posters_per_circular = 4;
int: posters_per_rectangular = 4;

int: guests_per_circular = 8;
int: guests_per_rectangular = 12;

int: space_per_circular = 15;
int: space_per_rectangular = 20;

% Minimum requirements and available space
int: min_participants = 500;
int: min_poster_boards = 300;
int: total_space = 1900;

% Simple derived upper bounds from space (for bounded decision variables)
int: max_circular_by_space = total_space div space_per_circular;
int: max_rectangular_by_space = total_space div space_per_rectangular;


% Variables
var 0..max_circular_by_space: num_circular_tables;        % number of circular tables to set up
var 0..max_rectangular_by_space: num_rectangular_tables;  % number of rectangular tables to set up

% Total catered guests (linked by constraint below)
var 0..(guests_per_circular*max_circular_by_space + guests_per_rectangular*max_rectangular_by_space): total_catered_guests;


% Constraints
% Link total catered guests to the chosen number of tables
constraint
  total_catered_guests =
    guests_per_circular * num_circular_tables +
    guests_per_rectangular * num_rectangular_tables;

% Meet minimum required participants capacity
constraint
  participants_per_circular * num_circular_tables +
  participants_per_rectangular * num_rectangular_tables
  >= min_participants;

% Meet minimum required poster boards capacity
constraint
  posters_per_circular * num_circular_tables +
  posters_per_rectangular * num_rectangular_tables
  >= min_poster_boards;

% Do not exceed available space
constraint
  space_per_circular * num_circular_tables +
  space_per_rectangular * num_rectangular_tables
  <= total_space;


% Objective
solve maximize total_catered_guests;