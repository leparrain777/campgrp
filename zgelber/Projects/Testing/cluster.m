function output = cluster(input, threshold)

	function distance = dis(p1, p2)
		distance = sqrt(sum((p1-p2).^2));
	end

	function midpoint = mid(p1, p2, p1_weight, p2_weight)
		midpoint = ((p1*p1_weight)+(p2*p2_weight))/(p1_weight+p2_weight);
	end
    if size(input, 2) == 1
        input = [input; 1];
        output = input;
        return;
    end
    orig_length = length(input);
    checked_and_cluster = -1*ones(2, length(input));
    magnitude = ones(1, length(input));
    input = [input; magnitude];
    input = [input; checked_and_cluster];

	%Ice ---
	%Ant ---
	%CO2 ---
	%Chk ---
	%Gro ---

    cluster_num = 1;
    array_length = length(input);
    index = 1;
    while index <= array_length
        cluster_checker = false;
%        disp(input(:, index))
        if input(end-1, index) ~= -1 | (sum(isnan(input([1:end-3], index))) > 0)
            index = index + 1;
%	    disp('skipperino')
            continue;
        end
%	disp('-----comp against-----')
        p1 = input([1:end-3], index);
        p1_weight = input(end-2, index);
        for j=index+1:array_length
	    if input(end-1, j) ~= -1 | (sum(isnan(input([1:end-3], j))) > 0)
	        continue;
	    end
 %           disp(input(:, j))
            p2 = input([1:end-3], j);
            p2_weight = input(end-2, j);
            if dis(p1, p2) <= threshold
		cluster_checker = true;
		input(end-1, index) = 1;
		input(end-1, j) = 1;
%		disp(dis(p1, p2))
	        if input(end, index) ~= -1
		    if input(end, j) ~= -1
		        temp = input(end, j);
			for k=1:length(input)
			    if input(end, k) == temp
			        input(end, k) = input(end, index);
			    end
			end
		    else
		        input(end, j) = input(end, index);
		    end
		else
		    if input(end, j) ~= -1
		        input(end, index) = input(end, j);
		    else
		        input(end, index) = cluster_num;
			input(end, j) = cluster_num;
			cluster_num = cluster_num + 1;
		    end
	        end
	        new = mid(p1, p2, p1_weight, p2_weight);
	        add_to_input = [new; input(end-2, index)+input(end-2,j); -1; input(end, index)];
%	        disp('=====')
%	        disp('new boi')
 %               disp(add_to_input)
%	        disp('=====')
	        input = [input, add_to_input];
                array_length = array_length + 1;
	        break;
	    end
        end
        if cluster_checker | input(end, index) ~= -1
            index = index + 1;
	    continue;
	end
	input(end, index) = cluster_num;
        cluster_num = cluster_num + 1;
        index = index + 1;
%	disp('why am I here')
 %       disp('--------------------')
    end
    %output = input
    output = input(:, [1:orig_length]);
    output([end-2:end-1],:) = [];
    bad_indices = find(output(end, :) == -1);
    output(:, bad_indices) = [];	
end
