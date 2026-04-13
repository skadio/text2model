% Parameters (with values embedded)
int: participants_req = 500;
int: posterboards_req = 300;
int: space_avail = 1900;

int: circ_participants = 5;
int: circ_posterboards = 4;
int: circ_space = 15;
int: circ_guests = 8;

int: rect_participants = 4;
int: rect_posterboards = 4;
int: rect_space = 20;
int: rect_guests = 12;

% Variables
int: max_circ = space_avail div circ_space;
int: max_rect = space_avail div rect_space;

var 0..max_circ: n_circ;
var 0..max_rect: n_rect;

var 0..(circ_guests*max_circ + rect_guests*max_rect): total_guests;

% Constraints
constraint circ_space * n_circ + rect_space * n_rect <= space_avail;

constraint circ_participants * n_circ + rect_participants * n_rect >= participants_req;
constraint circ_posterboards * n_circ + rect_posterboards * n_rect >= posterboards_req;

constraint total_guests = circ_guests * n_circ + rect_guests * n_rect;

% Objective
solve maximize total_guests;