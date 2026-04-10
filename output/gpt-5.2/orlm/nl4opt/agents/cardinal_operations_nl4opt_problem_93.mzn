% Parameters
int: posters_per_circular = 4;        % poster boards per circular table
int: participants_per_circular = 5;   % participants per circular table
int: guests_per_circular = 8;         % guests catered per circular table
int: space_per_circular = 15;         % space units per circular table

int: posters_per_rectangular = 4;      % poster boards per rectangular table
int: participants_per_rectangular = 4; % participants per rectangular table
int: guests_per_rectangular = 12;      % guests catered per rectangular table
int: space_per_rectangular = 20;       % space units per rectangular table

int: min_participants = 500;           % minimum required participants capacity
int: min_posters = 300;                % minimum required poster boards capacity
int: max_space = 1900;                 % available space units

% Upper bounds from space limit (safe integer bounds)
int: max_circular = max_space div space_per_circular;
int: max_rectangular = max_space div space_per_rectangular;

% Variables
var 0..max_circular: num_circular_tables;        % number of circular tables to set up
var 0..max_rectangular: num_rectangular_tables;  % number of rectangular tables to set up

var 0..(guests_per_circular * max_circular + guests_per_rectangular * max_rectangular): total_guests; % total catered guests
var 0..(participants_per_circular * max_circular + participants_per_rectangular * max_rectangular): total_participants; % total participant capacity
var 0..(posters_per_circular * max_circular + posters_per_rectangular * max_rectangular): total_posters; % total poster boards capacity
var 0..max_space: total_space_used; % total space used

% Constraints
% --- Link totals to decision variables (linear definitions) ---
constraint
  total_guests =
    guests_per_circular * num_circular_tables +
    guests_per_rectangular * num_rectangular_tables;

constraint
  total_participants =
    participants_per_circular * num_circular_tables +
    participants_per_rectangular * num_rectangular_tables;

constraint
  total_posters =
    posters_per_circular * num_circular_tables +
    posters_per_rectangular * num_rectangular_tables;

constraint
  total_space_used =
    space_per_circular * num_circular_tables +
    space_per_rectangular * num_rectangular_tables;

% --- Minimum capacity requirements ---
constraint total_participants >= min_participants;
constraint total_posters >= min_posters;

% --- Space availability constraint ---
constraint total_space_used <= max_space;

% Objective
solve maximize total_guests;