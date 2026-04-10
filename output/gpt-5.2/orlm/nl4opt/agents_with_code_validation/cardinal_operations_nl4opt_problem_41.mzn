% Parameters
int: total_batter = 20000;              % Total batter available (grams)
int: total_milk   = 14000;              % Total milk available (grams)

int: batter_crepe    = 400;             % Batter per crepe cake (grams)
int: milk_crepe      = 200;             % Milk per crepe cake (grams)
int: profit_crepe    = 12;              % Profit per crepe cake ($)

int: batter_sponge   = 500;             % Batter per sponge cake (grams)
int: milk_sponge     = 300;             % Milk per sponge cake (grams)
int: profit_sponge   = 10;              % Profit per sponge cake ($)

int: batter_birthday = 450;             % Batter per birthday cake (grams)
int: milk_birthday   = 350;             % Milk per birthday cake (grams)
int: profit_birthday = 15;              % Profit per birthday cake ($)

% Variables
var 0..(total_batter div batter_crepe):    n_crepe;      % Number of crepe cakes
var 0..(total_batter div batter_sponge):   n_sponge;     % Number of sponge cakes
var 0..(total_batter div batter_birthday): n_birthday;   % Number of birthday cakes

% Upper bound: produce max of each (by batter) and sum profits
var 0..(profit_crepe * (total_batter div batter_crepe)
      + profit_sponge * (total_batter div batter_sponge)
      + profit_birthday * (total_batter div batter_birthday)): total_profit;

% Constraints
% Total batter used cannot exceed available batter
constraint
  batter_crepe * n_crepe
+ batter_sponge * n_sponge
+ batter_birthday * n_birthday
<= total_batter;

% Total milk used cannot exceed available milk
constraint
  milk_crepe * n_crepe
+ milk_sponge * n_sponge
+ milk_birthday * n_birthday
<= total_milk;

% Define total profit from produced cakes
constraint
  total_profit =
    profit_crepe * n_crepe
  + profit_sponge * n_sponge
  + profit_birthday * n_birthday;

% Objective
solve maximize total_profit;