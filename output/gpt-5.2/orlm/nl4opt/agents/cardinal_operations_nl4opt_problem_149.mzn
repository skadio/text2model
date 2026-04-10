% Parameters
int: budget = 2000;                 % Maximum total spend ($)
int: space_capacity = 200;          % Maximum desk space available (sq ft)

int: cost_long = 300;               % Cost per long desk ($)
int: space_long = 10;               % Space per long desk (sq ft)
int: seats_long = 6;                % Seats per long desk

int: cost_short = 100;              % Cost per short desk ($)
int: space_short = 4;               % Space per short desk (sq ft)
int: seats_short = 2;               % Seats per short desk

% Variables
var 0..(budget div cost_long): n_long;        % Number of long desks to buy
var 0..(budget div cost_short): n_short;      % Number of short desks to buy

var 0..(seats_long * (budget div cost_long) + seats_short * (budget div cost_short)): total_seats;
                                              % Total seating capacity

% Constraints
% Budget constraint: total spend on desks cannot exceed the available budget
constraint
  cost_long * n_long + cost_short * n_short <= budget;

% Space constraint: total desk footprint cannot exceed office space capacity
constraint
  space_long * n_long + space_short * n_short <= space_capacity;

% Total seats definition: compute seating capacity from selected desks
constraint
  total_seats = seats_long * n_long + seats_short * n_short;

% Objective
solve maximize total_seats;