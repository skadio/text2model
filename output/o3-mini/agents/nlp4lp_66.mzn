include "globals.mzn";

/* Input parameters */
int: n;
int: StartCity;                   % the given start city index (may be 0-based)
array[1..n, 1..n] of int: Distances;  % symmetric distance matrix

/* Adjust the start city to 1..n indexing.
   If StartCity is given as 0 then treat it as city 1 */
int: start = if StartCity = 0 then 1 else StartCity endif;

/* Decision variables */
/* The successor array defines the tour as a circuit:
   For each city i (1..n), succ[i] is the next city visited. */
array[1..n] of var 1..n: succ;
constraint circuit(succ);

/* To fix the starting city in the tour (break the rotational symmetry)
   we introduce position variables.
   pos[i] is the position (1..n) of city i in the tour.
   We force the designated start city to appear first.
   The linking between succ and pos is given by:
       if city i is at position p < n then its successor must be at position p+1,
       otherwise (if p=n) its successor must be at position 1.
*/
array[1..n] of var 1..n: pos;
constraint pos[start] = 1;
constraint forall(i in 1..n) (
  if pos[i] < n then
    pos[succ[i]] = pos[i] + 1
  else
    pos[succ[i]] = 1
  endif
);

/* Define the total travel distance of the tour.
   For each city i, we add the distance from city i to its successor succ[i].
   Since the circuit constraint guarantees a Hamiltonian cycle,
   this sums the distances along the whole route. */
var int: totalDistance = sum(i in 1..n)(Distances[i, succ[i]]);

/* Solve: we want to minimize the total travel distance */
solve minimize totalDistance;

/* Output:
   We output the total distance and also show the tour in successor‐form.
   One can reconstruct the ordered route by following the successors starting at the fixed start city.
*/
output [
  "Total Distance = ", show(totalDistance), "\n",
  "Successor representation (city -> next city): ", show(succ), "\n",
  "Positions in tour (city: position): ", show([ i ++ ":" ++ show(pos[i]) | i in 1..n ]), "\n"
];