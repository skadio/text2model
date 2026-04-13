% Parameters
int: audience_pop = 100;          % Audience members per pop concert
int: practice_days_pop = 2;       % Practice days required per pop concert
int: audience_rnb = 240;          % Audience members per R&B concert
int: practice_days_rnb = 4;       % Practice days required per R&B concert

int: min_total_audience = 10000;  % Minimum total audience required
int: max_practice_days = 180;     % Total practice days available

int: max_rnb_percent = 40;        % Max percentage of concerts that can be R&B (integer percent)

% Variables
% Upper bounds are safe coarse bounds based on meeting audience with only one concert type.
var 0..ceil(min_total_audience div audience_pop): pop_concerts;  % Number of pop concerts
var 0..ceil(min_total_audience div audience_rnb): rnb_concerts;  % Number of R&B concerts

var 0..(ceil(min_total_audience div audience_pop) + ceil(min_total_audience div audience_rnb)):
    total_concerts; % Total concerts

% Constraints
% --- Total concerts definition ---
constraint total_concerts = pop_concerts + rnb_concerts;

% --- Minimum total audience requirement ---
constraint audience_pop * pop_concerts + audience_rnb * rnb_concerts >= min_total_audience;

% --- Practice days availability constraint ---
constraint practice_days_pop * pop_concerts + practice_days_rnb * rnb_concerts <= max_practice_days;

% --- R&B proportion cap (avoid division by cross-multiplying) ---
% rnb_concerts / total_concerts <= max_rnb_percent/100  <=>  100*rnb_concerts <= max_rnb_percent*total_concerts
constraint 100 * rnb_concerts <= max_rnb_percent * total_concerts;

% Objective
solve minimize total_concerts;