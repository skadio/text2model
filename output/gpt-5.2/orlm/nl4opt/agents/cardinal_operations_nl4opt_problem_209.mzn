% Parameters
int: camel_capacity = 50;          % packages carried per camel
int: horse_capacity = 60;          % packages carried per horse
int: camel_food = 20;              % food units required per camel
int: horse_food = 30;              % food units required per horse
int: min_packages = 1000;          % minimum packages to deliver
int: available_food = 450;         % total available food units

% Variables
% Upper bounds: with only this animal type, how many are needed to reach min_packages
% (use ceil division written as: (a + b - 1) div b)
var 0..((min_packages + camel_capacity - 1) div camel_capacity): camels;  % number of camels used
var 0..((min_packages + horse_capacity - 1) div horse_capacity): horses;  % number of horses used

% Constraints
% Package delivery requirement: total carried packages must meet or exceed demand
constraint camel_capacity * camels + horse_capacity * horses >= min_packages;

% Food availability constraint: total food consumed cannot exceed available food
constraint camel_food * camels + horse_food * horses <= available_food;

% Climate suitability constraint: horses cannot exceed camels
constraint horses <= camels;

% Objective
solve minimize (camels + horses);