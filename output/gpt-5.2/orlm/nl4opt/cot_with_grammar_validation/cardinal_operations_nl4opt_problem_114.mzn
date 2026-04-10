% Parameters
int: throat_time = 5;
int: nasal_time = 3;
int: min_nasal = 30;
int: throat_to_nasal_ratio = 4; % throat >= 4 * nasal
int: total_minutes = 20000;

% Variables
var 0..(total_minutes div throat_time): throat;
var 0..(total_minutes div nasal_time): nasal;

% Constraints
constraint nasal >= min_nasal;
constraint throat >= throat_to_nasal_ratio * nasal;
constraint throat_time * throat + nasal_time * nasal <= total_minutes;

% Objective
solve maximize (throat + nasal);