% Science fair table selection (maximize catered guests)
% All data embedded as requested.

include "globals.mzn";

% Decision variables
var 0..200: c;  % number of circular tables
var 0..200: r;  % number of rectangular tables

% Data
int: circ_participants = 5;
int: rect_participants = 4;

int: circ_posters = 4;
int: rect_posters = 4;

int: circ_guests = 8;
int: rect_guests = 12;

int: circ_space = 15;
int: rect_space = 20;

int: min_participants = 500;
int: min_posters = 300;
int: max_space = 1900;

% Constraints
constraint circ_space * c + rect_space * r <= max_space;
constraint circ_participants * c + rect_participants * r >= min_participants;
constraint circ_posters * c + rect_posters * r >= min_posters;

% Objective: maximize catered guests
var int: total_guests = circ_guests * c + rect_guests * r;

solve maximize total_guests;

output [
  "circular_tables = ", show(c), "\n",
  "rectangular_tables = ", show(r), "\n",
  "total_guests = ", show(total_guests), "\n",
  "total_space = ", show(circ_space*c + rect_space*r), "\n",
  "total_participants = ", show(circ_participants*c + rect_participants*r), "\n",
  "total_poster_boards = ", show(circ_posters*c + rect_posters*r), "\n"
];