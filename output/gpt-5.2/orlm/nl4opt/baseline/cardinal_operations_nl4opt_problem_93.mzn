% Science fair table selection (maximize catered guests)
% Data embedded in model

int: space_available = 1900;

% Per-table capacities
int: posters_per_circular = 4;
int: participants_per_circular = 5;
int: guests_per_circular = 8;
int: space_per_circular = 15;

int: posters_per_rect = 4;
int: participants_per_rect = 4;
int: guests_per_rect = 12;
int: space_per_rect = 20;

% Requirements
int: min_participants = 500;
int: min_posters = 300;

% Decision variables
var 0..(space_available div space_per_circular): c; % number of circular tables
var 0..(space_available div space_per_rect): r;     % number of rectangular tables

% Constraints
constraint space_per_circular * c + space_per_rect * r <= space_available;
constraint participants_per_circular * c + participants_per_rect * r >= min_participants;
constraint posters_per_circular * c + posters_per_rect * r >= min_posters;

% Objective: maximize catered guests
var int: total_guests = guests_per_circular * c + guests_per_rect * r;
solve maximize total_guests;

output [
  "circular_tables=", show(c), "\n",
  "rectangular_tables=", show(r), "\n",
  "total_guests=", show(total_guests), "\n",
  "total_space=", show(space_per_circular * c + space_per_rect * r), "\n",
  "total_participants=", show(participants_per_circular * c + participants_per_rect * r), "\n",
  "total_poster_boards=", show(posters_per_circular * c + posters_per_rect * r), "\n"
];