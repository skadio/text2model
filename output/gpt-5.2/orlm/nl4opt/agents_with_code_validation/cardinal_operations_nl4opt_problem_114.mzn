% Parameters
int: throat_time = 5;          % minutes per throat swab
int: nasal_time  = 3;          % minutes per nasal swab
int: min_nasal   = 30;         % at least this many nasal swabs
int: throat_per_nasal = 4;     % throat swabs must be at least this multiple of nasal
int: total_time  = 20000;      % total available clinic minutes

% Upper bounds derived from total_time (for bounded decision variables)
int: max_throat = total_time div throat_time;  % maximum possible throat swabs if only throat
int: max_nasal  = total_time div nasal_time;   % maximum possible nasal swabs if only nasal

% Variables
var 0..max_throat: throat_swabs;   % number of throat swabs performed
var 0..max_nasal:  nasal_swabs;    % number of nasal swabs performed

% Constraints
% --- Minimum nasal swabs requirement ---
constraint nasal_swabs >= min_nasal;

% --- Ratio requirement: at least 4 times as many throat swabs as nasal swabs ---
constraint throat_swabs >= throat_per_nasal * nasal_swabs;

% --- Total clinic time capacity constraint ---
constraint throat_time * throat_swabs + nasal_time * nasal_swabs <= total_time;

% Objective
solve maximize throat_swabs + nasal_swabs;