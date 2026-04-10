% Parameters
int: vitC_per_shots = 30;           % vitamin C units needed per batch of shots
int: vitD_per_shots = 40;           % vitamin D units needed per batch of shots
int: vitC_per_pills = 50;           % vitamin C units needed per batch of pills
int: vitD_per_pills = 30;           % vitamin D units needed per batch of pills

int: vitC_available = 1200;         % total available vitamin C units
int: vitD_available = 1500;         % total available vitamin D units

int: people_per_shots = 10;         % people supplied per batch of shots
int: people_per_pills = 7;          % people supplied per batch of pills

int: max_shots_batches = 10;        % maximum number of batches of shots allowed


% Variables
var 0..max_shots_batches: batches_shots;  % number of batches of vitamin shots

% Upper bound for pills based on resource-only maxima (safe, possibly loose)
var 0..max(vitC_available div vitC_per_pills,
           vitD_available div vitD_per_pills): batches_pills;  % number of batches of vitamin pills

% Total people supplied (linked by constraint below)
var 0..(people_per_shots * max_shots_batches
        + people_per_pills * max(vitC_available div vitC_per_pills,
                                 vitD_available div vitD_per_pills)): total_people;


% Constraints
% Link total_people to the chosen production plan
constraint
  total_people = people_per_shots * batches_shots
               + people_per_pills * batches_pills;

% Resource capacity constraints (cannot exceed available vitamins)
constraint
  vitC_per_shots * batches_shots + vitC_per_pills * batches_pills <= vitC_available;

constraint
  vitD_per_shots * batches_shots + vitD_per_pills * batches_pills <= vitD_available;

% Popularity constraint: pills must be produced in strictly larger quantity than shots
constraint
  batches_pills > batches_shots;


% Objective
solve maximize total_people;