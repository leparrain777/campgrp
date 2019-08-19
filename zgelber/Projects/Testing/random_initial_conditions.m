function n0 = random_initial_conditions(Vbegin, Vend, Abegin, Aend, Cbegin, Cend)

%Creates a random set of initial conditions using the ranges specified in the parameter file.
	V = Vbegin + (Vend-Vbegin)*rand(1,1);
        A = Abegin + (Aend-Abegin)*rand(1,1);
        C = Cbegin + (Cend-Cbegin)*rand(1,1);
        n0=[V,A,C];
end
