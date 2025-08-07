include "globals.mzn";

int: num_people;  % Number of people in the kidney exchange program
array[1..num_people, 1..num_people] of int: compatible;  % Compatibility matrix

/* Variables */
array[1..num_people] of var 0..1: donate;  % 1 if person donates, 0 otherwise
array[1..num_people] of var 0..1: receive;  % 1 if person receives, 0 otherwise

/* Constraints */
constraint count(donate, 1, sum(receive));  % Each donor must receive one kidney

/* Ensure that if a person donates, they must be compatible with someone who receives */
constraint forall(i in 1..num_people)(
    donate[i] = 1 -> sum(j in 1..num_people)(compatible[i,j] * receive[j]) > 0
);

/* Objective: Maximize the number of exchanges */
var 0..num_people: total_exchanges = sum(donate);  % Total number of donors

solve maximize total_exchanges;

/* Output */
output [ "Total exchanges = ", show(total_exchanges), "\nDonations = ", show(donate), "\nReceives = ", show(receive), "\n" ];