classdef BaselineNetwork < MINetwork
    properties
        
    end
    methods
        function B = BaselineNetwork(n)
            B@MINetwork(n);
            B.LINKS = ones(B.N,B.n-1);
            for st = [1:B.n-1]
                for sw = [1:B.N/2^(st)]
                    B.LINKS(sw*2-1,st) = sw;
                    B.LINKS(sw*2,st) = sw + B.N/2^st;
                end
                for k = [1:2^(st-1)-1]
                    B.LINKS([k*B.N/2^(st-1)+1:(k+1)*B.N/2^(st-1)],st) = B.LINKS([1:B.N/2^(st-1)],st) + B.N*k/2^(st-1);
                end
            end    
        end   
    end
end

        