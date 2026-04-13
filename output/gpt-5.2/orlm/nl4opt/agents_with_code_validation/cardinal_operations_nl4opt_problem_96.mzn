% Parameters
int: fat_per_burger = 10;              % fat units in one burger
int: calories_per_burger = 300;        % calories in one burger
int: cholesterol_per_burger = 12;      % cholesterol units in one burger

int: fat_per_pizza = 8;                % fat units in one slice of pizza
int: calories_per_pizza = 250;         % calories in one slice of pizza
int: cholesterol_per_pizza = 10;       % cholesterol units in one slice of pizza

int: min_fat = 130;                    % minimum required fat units
int: min_calories = 3000;              % minimum required calories

% Variables
var 0..1000: burgers;                  % number of burgers to eat (non-negative integer)
var 0..1000: pizza_slices;             % number of pizza slices to eat (non-negative integer)

var 0..1000000: total_fat;             % total fat intake
var 0..1000000: total_calories;        % total calories intake
var 0..1000000: total_cholesterol;     % total cholesterol intake

% Constraints
% Link totals to decision variables
constraint
  total_fat =
    fat_per_burger * burgers +
    fat_per_pizza * pizza_slices;

constraint
  total_calories =
    calories_per_burger * burgers +
    calories_per_pizza * pizza_slices;

constraint
  total_cholesterol =
    cholesterol_per_burger * burgers +
    cholesterol_per_pizza * pizza_slices;

% Minimum nutrition requirements
constraint total_fat >= min_fat;
constraint total_calories >= min_calories;

% Preference/relationship constraint: at least twice as many pizza slices as burgers
constraint pizza_slices >= 2 * burgers;

% Objective
solve minimize total_cholesterol;