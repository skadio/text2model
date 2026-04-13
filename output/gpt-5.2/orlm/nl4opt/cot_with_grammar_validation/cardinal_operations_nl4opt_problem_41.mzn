% Parameters
int: total_batter = 20000;
int: total_milk   = 14000;

int: batter_crepe     = 400;
int: milk_crepe       = 200;
int: profit_crepe     = 12;

int: batter_sponge    = 500;
int: milk_sponge      = 300;
int: profit_sponge    = 10;

int: batter_birthday  = 450;
int: milk_birthday    = 350;
int: profit_birthday  = 15;

% Variables
var 0..(total_batter div batter_crepe):    x_crepe;
var 0..(total_batter div batter_sponge):   x_sponge;
var 0..(total_batter div batter_birthday): x_birthday;

var int: total_profit;

% Constraints
constraint batter_crepe * x_crepe + batter_sponge * x_sponge + batter_birthday * x_birthday <= total_batter;
constraint milk_crepe   * x_crepe + milk_sponge   * x_sponge + milk_birthday   * x_birthday <= total_milk;

constraint total_profit = profit_crepe * x_crepe + profit_sponge * x_sponge + profit_birthday * x_birthday;

% Objective
solve maximize total_profit;