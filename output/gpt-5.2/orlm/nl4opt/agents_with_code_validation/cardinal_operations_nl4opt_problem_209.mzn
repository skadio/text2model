% Parameters
int: camel_capacity = 50;        % packages per camel
int: horse_capacity = 60;        % packages per horse
int: camel_food = 20;            % food units required per camel
int: horse_food = 30;            % food units required per horse
int: min_packages = 1000;        % minimum packages to deliver
int: total_food_available = 450; % total food units available

% Useful bounds (derived)
int: max_camels_by_food = total_food_available div camel_food;   % floor(450/20)=22
int: max_horses_by_food = total_food_available div horse_food;   % floor(450/30)=15
int: max_animals = max_camels_by_food + max_horses_by_food;

% Variables
var 0..max_camels_by_food: num_camels;  % number of camels used
var 0..max_horses_by_food: num_horses;  % number of horses used
var 0..max_animals: total_animals;      % total number of animals used

% Constraints
% --- Total animals definition ---
constraint total_animals = num_camels + num_horses;

% --- Package delivery requirement ---
% Ensure at least the minimum number of packages are delivered.
constraint
  camel_capacity * num_camels + horse_capacity * num_horses >= min_packages;

% --- Food availability constraint ---
% Total food consumed by selected animals must not exceed available food.
constraint
  camel_food * num_camels + horse_food * num_horses <= total_food_available;

% --- Climate suitability constraint ---
% Number of horses cannot exceed number of camels.
constraint
  num_horses <= num_camels;

% Objective
solve minimize total_animals;