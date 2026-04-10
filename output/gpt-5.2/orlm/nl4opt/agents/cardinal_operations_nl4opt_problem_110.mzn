% Parameters
int: pill_time = 10;                 % minutes to administer one pill vaccine
int: shot_time = 20;                 % minutes to administer one shot vaccine
int: total_time = 10000;             % total clinic operating time in minutes
int: min_pills = 30;                 % minimum number of pill vaccines
int: shot_to_pill_ratio = 3;         % must deliver at least this many shots per pill

% Upper bounds derived from total_time (safe integer bounds)
int: max_pills = total_time div pill_time;
int: max_shots = total_time div shot_time;

% Variables
var 0..max_pills: pills;             % number of pill vaccines administered
var 0..max_shots: shots;             % number of shot vaccines administered
var 0..(max_pills + max_shots): total_vaccinated;  % total patients vaccinated

% Constraints
% Total time capacity: administration times cannot exceed available clinic time
constraint
  pill_time * pills + shot_time * shots <= total_time;

% Minimum number of pill vaccines that must be administered
constraint
  pills >= min_pills;

% Shot-to-pill ratio requirement: at least shot_to_pill_ratio shots per pill
constraint
  shots >= shot_to_pill_ratio * pills;

% Define total vaccinated as the sum of pill and shot vaccinations
constraint
  total_vaccinated = pills + shots;

% Objective
solve maximize total_vaccinated;