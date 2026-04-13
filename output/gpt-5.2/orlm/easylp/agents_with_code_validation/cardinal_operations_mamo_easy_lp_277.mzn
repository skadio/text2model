% Parameters
int: fatigue_strength = 6;   % fatigue per hour of strength training (X)
int: fatigue_endurance = 3;  % fatigue per hour of endurance training (Y)
int: fatigue_agility = 5;    % fatigue per hour of agility training (Z)

int: min_strength_plus_endurance = 8;   % X + Y >= 8
int: max_strength_plus_agility = 10;    % X + Z <= 10
int: min_endurance_minus_agility = 2;   % Y - Z >= 2

% Variables
var 0..100: hours_strength;   % weekly hours of strength training (X)
var 0..100: hours_endurance;  % weekly hours of endurance training (Y)
var 0..100: hours_agility;    % weekly hours of agility training (Z)

var 0..(100*(fatigue_strength + fatigue_endurance + fatigue_agility)): total_fatigue;
% Total weekly fatigue (objective), bounded for linear safety

% Constraints

% Link total fatigue to the allocated training hours
constraint total_fatigue =
    fatigue_strength * hours_strength
  + fatigue_endurance * hours_endurance
  + fatigue_agility * hours_agility;

% Basic fitness requirement: strength + endurance must be at least the minimum
constraint hours_strength + hours_endurance >= min_strength_plus_endurance;

% Overexertion limit: strength + agility must not exceed the maximum
constraint hours_strength + hours_agility <= max_strength_plus_agility;

% Balance requirement: endurance must exceed agility by at least the minimum difference
constraint hours_endurance - hours_agility >= min_endurance_minus_agility;

% Objective
solve minimize total_fatigue;