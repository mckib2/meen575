function [ f ] = lookup(x,obj)
    global LUT keyfmt nobj_saved;
    
    key = char(sprintf(keyfmt,x));
    if LUT.isKey(key)
        %fprintf('Found the key!\n');
        nobj_saved = nobj_saved + 1;
        f = LUT(key);
    else
        %fprintf('No key...\n');
        f = obj(x);
        LUT(key) = f;
    end
end