% Crepe / Sponge / Birthday cake production planning (integer linear optimization)

include "globals.mzn";

% Data (embedded as required)
int: batter_avail = 20000;
int: milk_avail   = 14000;

int: batter_crepe    = 400;
int: milk_crepe      = 200;
int: profit_crepe    = 12;

int: batter_sponge   = 500;
int: milk_sponge     = 300;
int: profit_sponge   = 10;

int: batter_birthday = 450;
int: milk_birthday   = 350;
int: profit_birthday = 15;

% Decision variables: number of each cake to make
var 0..(batter_avail div min([batter_crepe, batter_sponge, batter_birthday])): n_crepe;
var 0..(batter_avail div min([batter_crepe, batter_sponge, batter_birthday])): n_sponge;
var 0..(batter_avail div min([batter_crepe, batter_sponge, batter_birthday])): n_birthday;

% Resource constraints
constraint batter_crepe    * n_crepe
         + batter_sponge   * n_sponge
         + batter_birthday * n_birthday <= batter_avail;

constraint milk_crepe      * n_crepe
         + milk_sponge     * n_sponge
         + milk_birthday   * n_birthday <= milk_avail;

% Objective: maximize total profit
var int: total_profit =
    profit_crepe    * n_crepe
  + profit_sponge   * n_sponge
  + profit_birthday * n_birthday;

solve maximize total_profit;

output [
  "Crepe cakes    = ", show(n_crepe), "\n",
  "Sponge cakes   = ", show(n_sponge), "\n",
  "Birthday cakes = ", show(n_birthday), "\n",
  "Total profit   = $", show(total_profit), "\n",
  "Batter used    = ", show(batter_crepe*n_crepe + batter_sponge*n_sponge + batter_birthday*n_birthday),
  " / ", show(batter_avail), " g\n",
  "Milk used      = ", show(milk_crepe*n_crepe + milk_sponge*n_sponge + milk_birthday*n_birthday),
  " / ", show(milk_avail), " g\n"
];