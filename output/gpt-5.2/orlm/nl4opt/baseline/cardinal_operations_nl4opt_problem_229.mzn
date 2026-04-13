int: total_land = 100;

float: prod_heap = 3.0;
float: waste_heap = 8.0;
int: machines_heap = 10;

float: prod_vat = 5.0;
float: waste_vat = 17.0;
int: machines_vat = 20;

int: machines_available = 100;
float: waste_limit = 90.0;

var 0.0..total_land: heap_land;
var 0.0..total_land: vat_land;

constraint heap_land + vat_land <= total_land;
constraint machines_heap * heap_land + machines_vat * vat_land <= machines_available;
constraint waste_heap * heap_land + waste_vat * vat_land <= waste_limit;

var float: total_production = prod_heap * heap_land + prod_vat * vat_land;

solve maximize total_production;

output [
  "heap_land = ", show(heap_land), "\n",
  "vat_land = ", show(vat_land), "\n",
  "heap_proportion = ", show(heap_land / total_land), "\n",
  "vat_proportion = ", show(vat_land / total_land), "\n",
  "total_production = ", show(total_production), "\n",
  "total_waste = ", show(waste_heap * heap_land + waste_vat * vat_land), "\n",
  "total_machines = ", show(machines_heap * heap_land + machines_vat * vat_land), "\n"
];