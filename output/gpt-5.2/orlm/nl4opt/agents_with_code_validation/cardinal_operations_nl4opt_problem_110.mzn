% Parameters
int: pill_time = 10;          % minutes per pill vaccine
int: shot_time = 20;          % minutes per shot vaccine
int: total_time = 10000;      % total available operating minutes
int: min_pills = 30;          % minimum number of pill vaccines
int: shot_to_pill_ratio = 3;  % must deliver at least this many shots per pill

% Variables
var 0..(total_time div pill_time): pill_count;  % number of pill vaccines administered
var 0..(total_time div shot_time): shot_count;  % number of shot vaccines administered
var 0..(total_time div min(pill_time, shot_time)): total_patients; % total vaccinated

% Constraints

% Time capacity: total administration time cannot exceed available clinic time
constraint
  pill_time * pill_count + shot_time * shot_count <= total_time;

% Minimum pill vaccines requirement
constraint
  pill_count >= min_pills;

% Shot-to-pill ratio: must deliver at least shot_to_pill_ratio times as many shots as pills
constraint
  shot_count >= shot_to_pill_ratio * pill_count;

% Total patients definition: each vaccine administered corresponds to one patient
constraint
  total_patients = pill_count + shot_count;

% Objective
solve maximize total_patients;