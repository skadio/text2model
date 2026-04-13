int: BUDGET = 760000;
float: PROFIT_CONDO = 0.50;
float: PROFIT_HOUSE = 1.00;
float: MIN_CONDO_FRAC = 0.20;
int: MIN_HOUSE_INVEST = 20000;

var float: x_condo;
var float: x_house;

constraint x_condo >= 0.0;
constraint x_house >= 0.0;
constraint x_condo + x_house <= float(BUDGET);
constraint x_condo >= MIN_CONDO_FRAC * (x_condo + x_house);
constraint x_house >= float(MIN_HOUSE_INVEST);

solve maximize PROFIT_CONDO * x_condo + PROFIT_HOUSE * x_house;

output [
  "x_condo=", show(x_condo), "\n",
  "x_house=", show(x_house), "\n",
  "profit=", show(PROFIT_CONDO * x_condo + PROFIT_HOUSE * x_house), "\n"
];