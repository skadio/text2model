% Parameters
int: max_total_hours = 30;               % Maximum total training hours available
int: min_extra_cardio_over_strength = 5; % Cardio hours must be at least this many more than strength
int: max_flex_cardio_diff = 10;          % |flexibility - cardio| must be at most this

int: fatigue_cardio = 10;                % Fatigue per hour of cardio (X)
int: fatigue_strength = 15;              % Fatigue per hour of strength (Y)
int: fatigue_flexibility = 20;           % Fatigue per hour of flexibility (Z)

% Variables
var 0..max_total_hours: X;               % Hours of cardio
var 0..max_total_hours: Y;               % Hours of strength training
var 0..max_total_hours: Z;               % Hours of flexibility training

var 0..(fatigue_cardio*max_total_hours
      + fatigue_strength*max_total_hours
      + fatigue_flexibility*max_total_hours): total_fatigue; % Total fatigue score

% Constraints
% Total hours limit across all exercise types
constraint X + Y + Z <= max_total_hours;

% Cardio must be at least a fixed amount more than strength
constraint X >= Y + min_extra_cardio_over_strength;

% Flexibility and cardio hours must be within a maximum absolute difference
constraint abs(Z - X) <= max_flex_cardio_diff;

% Define total fatigue as the weighted sum of hours by fatigue per hour
constraint total_fatigue = fatigue_cardio * X
                         + fatigue_strength * Y
                         + fatigue_flexibility * Z;

% Objective
solve minimize total_fatigue;