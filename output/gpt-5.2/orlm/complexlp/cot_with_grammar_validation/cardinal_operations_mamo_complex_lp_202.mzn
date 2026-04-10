float: price_meaties = 2.80;
float: price_yummies = 2.00;

float: cereal_per_meaties = 2.0;
float: meat_per_meaties = 3.0;
float: cereal_per_yummies = 3.0;
float: meat_per_yummies = 1.5;

float: cost_cereal_per_lb = 0.20;
float: cost_meat_per_lb = 0.50;

float: pack_cost_meaties = 0.25;
float: pack_cost_yummies = 0.20;

float: cereal_available = 400000.0;
float: meat_available = 300000.0;

int: meaties_capacity = 90000;

var 0..meaties_capacity: meaties;
var 0..400000: yummies;

constraint cereal_per_meaties * int2float(meaties)
         + cereal_per_yummies * int2float(yummies)
         <= cereal_available;

constraint meat_per_meaties * int2float(meaties)
         + meat_per_yummies * int2float(yummies)
         <= meat_available;

var float: profit;
constraint profit =
    price_meaties * int2float(meaties) + price_yummies * int2float(yummies)
  - cost_cereal_per_lb * (cereal_per_meaties * int2float(meaties) + cereal_per_yummies * int2float(yummies))
  - cost_meat_per_lb * (meat_per_meaties * int2float(meaties) + meat_per_yummies * int2float(yummies))
  - pack_cost_meaties * int2float(meaties)
  - pack_cost_yummies * int2float(yummies);

solve maximize profit;

output [
  "meaties=", show(meaties), "\n",
  "yummies=", show(yummies), "\n",
  "profit=", show(profit), "\n"
];