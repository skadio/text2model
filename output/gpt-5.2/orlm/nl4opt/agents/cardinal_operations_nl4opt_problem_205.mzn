% Parameters
int: pop_audience = 100;            % audience members per pop concert
int: pop_practice_days = 2;         % practice days per pop concert
int: rb_audience = 240;             % audience members per R&B concert
int: rb_practice_days = 4;          % practice days per R&B concert

int: min_total_audience = 10000;    % minimum required total audience
int: max_total_practice_days = 180; % maximum available practice days

int: rb_max_percent = 40;           % maximum percentage of concerts that can be R&B

% Safe upper bounds (derived from limits) for decision variables
int: max_pop_by_days = max_total_practice_days div pop_practice_days; % 180/2 = 90
int: max_rb_by_days  = max_total_practice_days div rb_practice_days;  % 180/4 = 45
int: max_concerts_ub = max_pop_by_days + max_rb_by_days;              % 135

% Variables
var 0..max_pop_by_days: pop_concerts;        % number of pop concerts
var 0..max_rb_by_days: rb_concerts;          % number of R&B concerts
var 0..max_concerts_ub: total_concerts;      % total number of concerts (pop + R&B)

% Constraints

% --- Total concerts definition ---
constraint total_concerts = pop_concerts + rb_concerts;

% --- Audience requirement: reach at least the minimum total audience ---
constraint pop_audience * pop_concerts + rb_audience * rb_concerts >= min_total_audience;

% --- Practice days limit: do not exceed available practice days ---
constraint pop_practice_days * pop_concerts + rb_practice_days * rb_concerts <= max_total_practice_days;

% --- R&B share limit: at most rb_max_percent of all concerts are R&B ---
% Avoid division by cross-multiplying: 100 * rb_concerts <= rb_max_percent * total_concerts
constraint 100 * rb_concerts <= rb_max_percent * total_concerts;

% Objective
solve minimize total_concerts;