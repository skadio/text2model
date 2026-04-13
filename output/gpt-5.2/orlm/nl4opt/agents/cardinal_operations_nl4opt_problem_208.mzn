% Parameters
int: protein_alpha = 30;      % grams of protein per alpha bottle
int: sugar_alpha   = 20;      % grams of sugar per alpha bottle
int: cal_alpha     = 350;     % calories per alpha bottle

int: protein_omega = 20;      % grams of protein per omega bottle
int: sugar_omega   = 15;      % grams of sugar per omega bottle
int: cal_omega     = 300;     % calories per omega bottle

int: min_protein   = 100;     % minimum required protein (grams)
int: min_calories  = 2000;    % minimum required calories
int: omega_pct_max = 35;      % maximum percent of drinks that can be omega (in %)

% Conservative upper bound on bottles to keep the model finite.
int: max_bottles = 20;

% Variables
var 0..max_bottles: bottles_alpha;        % number of alpha bottles
var 0..max_bottles: bottles_omega;        % number of omega bottles
var 0..2*max_bottles: total_bottles;      % total bottles consumed (alpha + omega)
var 0..100000: total_sugar;               % total sugar intake (grams)

% Constraints

% Total bottles accounting
constraint total_bottles = bottles_alpha + bottles_omega;

% Minimum protein requirement
constraint protein_alpha * bottles_alpha + protein_omega * bottles_omega >= min_protein;

% Minimum calorie requirement
constraint cal_alpha * bottles_alpha + cal_omega * bottles_omega >= min_calories;

% Omega percentage limit: omega bottles <= omega_pct_max% of total bottles
% Cross-multiply to avoid division: 100 * omega <= omega_pct_max * total
constraint 100 * bottles_omega <= omega_pct_max * total_bottles;

% Define total sugar intake
constraint total_sugar = sugar_alpha * bottles_alpha + sugar_omega * bottles_omega;

% Objective
solve minimize total_sugar;