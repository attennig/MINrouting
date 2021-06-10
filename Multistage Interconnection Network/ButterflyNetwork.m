classdef ButterflyNetwork < MINetwork
    properties
        
    end
    methods
        function B = ButterflyNetwork(n)
            B@MINetwork(n);
            B.LINKS = ones(B.N,B.n-1);
            for st = [1:n-1]
                for sw = [0:B.N/2-1]    
                    p1 = 1 + sw*2;
                    p2 = 2 + sw*2;
                    sw_bin = dec2bin(sw,log2(B.N/2));
                    sw_bin_cross = sw_bin;
                    if sw_bin_cross(st) == '0'
                        sw_bin_cross(st)='1';
                    else
                        sw_bin_cross(st)='0';
                    end
                    sw_cross = bin2dec(sw_bin_cross);

                    if sw_bin(st) == '0'
                        p_s = p1;
                        p_c = p2;
                        p_c_next = 1 + sw_cross*2;
                    else
                        p_s = p2;
                        p_c = p1;
                        p_c_next = 2 + sw_cross*2;
                    end
                    B.LINKS(p_s,st) = p_s;
                    B.LINKS(p_c,st) = p_c_next;
                end
            end
        end
        
        
    end
end

        