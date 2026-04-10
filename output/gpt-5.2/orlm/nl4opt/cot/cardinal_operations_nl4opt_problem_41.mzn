% Parameters (with values embedded)
int: total_batter = 20000;
int: total_milk = 14000;

int: batter_crepe = 400;
int: milk_crepe = 200;
int: profit_crepe = 12;

int: batter_sponge = 500;
int: milk_sponge = 300;
int: profit_sponge = 10;

int: batter_birthday = 450;
int: milk_birthday = 350;
int: profit_birthday = 15;

% Variables
var 0..(total_batter div batter_crepe): crepe_cakes;
var 0..(total_batter div batter_sponge): sponge_cakes;
var 0..(total_batter div batter_birthday): birthday_cakes;

var int: total_profit;

% Constraints
constraint batter_crepe * crepe_cakes
         + batter_sponge * sponge_cakes
         + batter_birthday * birthday_cakes <= total_batter;

constraint milk_crepe * crepe_cakes
         + milk_sponge * sponge_cakes
         + milk_birthday * birthday_cakes <= total_milk;

constraint total_profit =
         profit_crepe * crepe_cakes
       + profit_sponge * sponge_cakes
       + profit_birthday * birthday_cakes;

% Objective
solve maximize total_profit;