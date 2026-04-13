% Bakery cake production optimization (all data embedded)

int: batter_available = 20000;
int: milk_available   = 14000;

int: batter_crepe    = 400;
int: milk_crepe      = 200;
int: profit_crepe    = 12;

int: batter_sponge   = 500;
int: milk_sponge     = 300;
int: profit_sponge   = 10;

int: batter_birthday = 450;
int: milk_birthday   = 350;
int: profit_birthday = 15;

var 0..batter_available div batter_crepe: crepe;
var 0..batter_available div batter_sponge: sponge;
var 0..batter_available div batter_birthday: birthday;

constraint batter_crepe * crepe + batter_sponge * sponge + batter_birthday * birthday <= batter_available;
constraint milk_crepe   * crepe + milk_sponge   * sponge + milk_birthday   * birthday <= milk_available;

var int: total_profit = profit_crepe * crepe + profit_sponge * sponge + profit_birthday * birthday;

solve maximize total_profit;

output [
  "crepe=", show(crepe), "\n",
  "sponge=", show(sponge), "\n",
  "birthday=", show(birthday), "\n",
  "total_profit=", show(total_profit), "\n"
];