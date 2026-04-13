% Parameters
int: budget = 2000;                 % Maximum total spend ($)
int: max_space = 200;               % Maximum total desk space (sq ft)

int: cost_long = 300;               % Cost of one long desk ($)
int: space_long = 10;               % Space of one long desk (sq ft)
int: seats_long = 6;                % Seats provided by one long desk

int: cost_short = 100;              % Cost of one short desk ($)
int: space_short = 4;               % Space of one short desk (sq ft)
int: seats_short = 2;               % Seats provided by one short desk

% Variables
var 0..(budget div cost_long): num_long;     % Number of long desks to buy
var 0..(budget div cost_short): num_short;   % Number of short desks to buy

var 0..(seats_long * (budget div cost_long) + seats_short * (budget div cost_short)): total_seats;
                                             % Total seating available (objective-related)

% Constraints
% Total seating definition
constraint
  total_seats = seats_long * num_long + seats_short * num_short;

% Budget constraint: do not exceed maximum spend
constraint
  cost_long * num_long + cost_short * num_short <= budget;

% Space constraint: do not exceed available desk space
constraint
  space_long * num_long + space_short * num_short <= max_space;

% Objective
solve maximize total_seats;