% Parameters
int: protein_alpha   = 30;   % grams of protein per alpha bottle
int: sugar_alpha     = 20;   % grams of sugar per alpha bottle
int: calories_alpha  = 350;  % calories per alpha bottle

int: protein_omega   = 20;   % grams of protein per omega bottle
int: sugar_omega     = 15;   % grams of sugar per omega bottle
int: calories_omega  = 300;  % calories per omega bottle

int: min_protein     = 100;  % minimum required protein (grams)
int: min_calories    = 2000; % minimum required calories
int: max_omega_percent = 35; % omega bottles must be at most 35% of total bottles

% Derived safe bounds for search (enough to meet calorie minimum with only that drink)
int: ub_alpha = (min_calories + calories_alpha - 1) div calories_alpha;
int: ub_omega = (min_calories + calories_omega - 1) div calories_omega;

% Variables
var 0..ub_alpha: bottles_alpha;  % number of alpha bottles
var 0..ub_omega: bottles_omega;  % number of omega bottles

% Total sugar intake (bounded by the maximum possible within bottle bounds)
var 0..(sugar_alpha * ub_alpha + sugar_omega * ub_omega): total_sugar;

% Constraints
% --- Nutrition minimums ---
constraint protein_alpha * bottles_alpha + protein_omega * bottles_omega >= min_protein;
constraint calories_alpha * bottles_alpha + calories_omega * bottles_omega >= min_calories;

% --- Omega proportion (caffeine limit) ---
% omega <= max_omega_percent% of total  <=>  100*omega <= max_omega_percent*(alpha+omega)
constraint 100 * bottles_omega <= max_omega_percent * (bottles_alpha + bottles_omega);

% --- Total sugar accounting ---
constraint total_sugar = sugar_alpha * bottles_alpha + sugar_omega * bottles_omega;

% Objective
solve minimize total_sugar;