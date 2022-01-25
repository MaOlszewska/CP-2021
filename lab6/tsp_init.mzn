include "globals.mzn";

int: Nodes;
set of int: NUM = 1..Nodes;
array[NUM,NUM] of int: Dist;
array[NUM] of var NUM: route;

constraint route[1] = 1;
constraint alldifferent(route);


var int: total_distance = sum(i in 1..(Nodes-1))(Dist[route[i], route[i+1]]) + Dist[route[Nodes], 1];
solve satisfy;
/*
TODO: 
- it's exactly the same as tsp_naive.mzn but just "satisfies" the constraints
*/

output ["distance: (total_distance)\nroute = (route)"];