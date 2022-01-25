include "globals.mzn";

int: Nodes;
set of int: NUM = 1..Nodes;
array[NUM,NUM] of int: Dist;

array[NUM,NUM] of var bool: flow;
array[NUM,NUM] of var 0..Nodes-1: visit_counter;

%TODO:
%a) flow related
constraint forall(i in NUM)(visit_counter[i,i] = 0); 
constraint forall(i in NUM)(flow[i,i] = false); 
%  1) total flow coming from every node should be equal 1  
%  2) total flow going into every node should be equal 1
constraint forall(i in NUM)(
  count([flow[i, j] | j in NUM where j != i], true, 1));
constraint forall(i in NUM)(
  count([flow[j, i] | j in NUM where j != i], true, 1));
%b) visit_counter related
%  1) visit counter for edges originating from the first node is 0
constraint forall(i in NUM where i > 1)(visit_counter[1, i] = 0); %------------------------------------------------------------------------------------
%  2) visit counter for inactive edges should be equal
constraint forall(i, j in NUM where i != j /\ flow[i, j] = false)(visit_counter[i, j] = 0); %-------------------------------------------------
%  3) total* visit counter for edges ending at the first node should equal Nodes - 1
constraint forall(i in NUM where i > 1 /\ flow[i, 1] = true)(visit_counter[i, 1] = Nodes-1);
%  4) total* visit counter for "normal" edges should be higher by 1 compared to the previous* edges
constraint forall(i,j in NUM where i != j /\ i > 1 /\ flow[i,j] = true)( 1 + sum(k in NUM where k != i /\ k != j)(visit_counter[k,i]) = visit_counter[i,j]);
%  total visit counter = sum of all the visit counters for the involved edges 
%  previous edge = edge with the end being start of the successor edge
%c) objective
%  1) just calculate it based on the flow :)
var int: total_distance = sum(i,j in NUM where i != j /\ flow[i,j] = true)(Dist[i,j]); 

solve minimize total_distance;

output ["total distance: \(total_distance)\n"] ++
       [if fix(flow[i,j]) then " -> \(j)" else "" endif | i, j in NUM];