% Parameters
% Fatigue per hour for each training type
int: fatigue_strength  = 6;  % X
int: fatigue_endurance = 3;  % Y
int: fatigue_agility   = 5;  % Z

% Training-hour constraints
int: min_strength_plus_endurance = 8;   % X + Y >= 8
int: max_strength_plus_agility   = 10;  % X + Z <= 10
int: min_endurance_minus_agility = 2;   % Y - Z >= 2


% Variables
% Weekly training hours (non-negative integers)
var 0..100: hours_strength;    % X
var 0..100: hours_endurance;   % Y
var 0..100: hours_agility;     % Z

% Total fatigue to minimize
var 0..10000: total_fatigue;


% Constraints
% Basic fitness requirement: strength + endurance must be at least the minimum
constraint hours_strength + hours_endurance >= min_strength_plus_endurance;

% Overexertion limit: strength + agility must not exceed the maximum
constraint hours_strength + hours_agility <= max_strength_plus_agility;

% Balance requirement: endurance must exceed agility by at least the minimum difference
constraint hours_endurance - hours_agility >= min_endurance_minus_agility;

% Total fatigue calculation from chosen training hours and per-hour fatigue rates
constraint total_fatigue =
    fatigue_strength * hours_strength
  + fatigue_endurance * hours_endurance
  + fatigue_agility * hours_agility;


% Objective
solve minimize total_fatigue;