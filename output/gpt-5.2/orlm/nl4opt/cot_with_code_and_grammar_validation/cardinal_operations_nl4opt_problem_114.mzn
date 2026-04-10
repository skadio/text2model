% Parameters
int: time_throat = 5;
int: time_nasal = 3;
int: min_nasal = 30;
int: throat_per_nasal = 4; % throat >= 4 * nasal
int: total_time = 20000;

% Variables
var 0..(total_time div time_throat): throat;
var 0..(total_time div time_nasal): nasal;

% Constraints
constraint nasal >= min_nasal;
constraint throat >= throat_per_nasal * nasal;
constraint time_throat * throat + time_nasal * nasal <= total_time;

% Objective
solve maximize throat + nasal;