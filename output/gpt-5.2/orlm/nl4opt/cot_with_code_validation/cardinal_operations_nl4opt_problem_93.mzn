% Parameters
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

% Variables
int: max_circ = max_space div circ_space;
int: max_rect = max_space div rect_space;

var 0..max_circ: n_circ;
var 0..max_rect: n_rect;

var 0..(circ_guests * max_circ + rect_guests * max_rect): total_guests;

% Constraints
constraint circ_participants * n_circ + rect_participants * n_rect >= min_participants;
constraint circ_posters * n_circ + rect_posters * n_rect >= min_posters;
constraint circ_space * n_circ + rect_space * n_rect <= max_space;

constraint total_guests = circ_guests * n_circ + rect_guests * n_rect;

% Objective
solve maximize total_guests;