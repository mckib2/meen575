% program to find displacements and stresses in a truss us FEM
clear;
Data;

[weight,stress] = Truss(ndof,bc,nelem,E,dens,Node,force,bc,Elem);
stress
weight
