% Parameters
int: time_throat = 5;
int: time_nasal = 3;
int: min_nasal = 30;
int: throat_to_nasal_ratio = 4; % throat >= 4 * nasal
int: total_time = 20000;

% Variables
var 0..(total_time div time_throat): throat;
var 0..(total_time div time_nasal): nasal;
var 0..(total_time div min(time_throat, time_nasal)): patients;

% Constraints
constraint nasal >= min_nasal;
constraint throat >= throat_to_nasal_ratio * nasal;
constraint time_throat * throat + time_nasal * nasal <= total_time;
constraint patients = throat + nasal;

% Objective
solve maximize patients;