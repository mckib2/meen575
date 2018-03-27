function [ children ] = cross(parents,crossrate)
    for ii = 1:size(parents,1)
        if rand(1) > crossrate
            % blend crossover
            r = rand(2,numel(parents(1,1).vs));
            arg1 = round(parents(ii,1).vs.*r(1,:) + parents(ii,2).vs.*(1-r(1,:)));
            arg2 = round(parents(ii,1).vs.*(1-r(2,:)) + parents(ii,2).vs.*r(2,:));
            children(ii,1) = test_model(arg1);
            children(ii,2) = test_model(arg2);
        else
            children(ii,:) = parents(ii,:);
        end
    end
end