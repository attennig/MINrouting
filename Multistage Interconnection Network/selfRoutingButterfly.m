function [P,S] = selfRoutingButterfly(out_perm, n, N)
    disp("This butterfly has "+N+" inputs/outputs and "+n+" stages");
    in_perm = [0:N-1];
    STEPS = dec2bin(out_perm);
    S = ones(N/2, n)*2;
    P = [in_perm' zeros(N, 2*n-1)];
    LINKS = ones(N,n-1);
    for st = [1:n-1]
        for sw = [0:N/2-1]    
            p1 = 1 + sw*2;
            p2 = 2 + sw*2;
            sw_bin = dec2bin(sw,log2(N/2));
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
            LINKS(p_s,st) = p_s;
            LINKS(p_c,st) = p_c_next;
        end
    end

    for k = [1:2:2*n]
        for port = [1:2:N]
            % APPLY STEPS
            if STEPS([port:port+1],ceil(k/2)) == ['1';'0']
                % cross
                if ~isnan(P(port,k))
                    S(ceil(port/2), ceil(k/2)) = 1;
                end
                P(port, k+1) = P(port+1,k);
                P(port+1, k+1) = P(port,k);
                app = STEPS(port,:);
                STEPS(port,:) = STEPS(port+1,:);
                STEPS(port+1,:) = app;
            else
                if STEPS([port:port+1],ceil(k/2)) == ['0';'1']
                    % straight
                    if ~isnan(P(port,k))
                        S(ceil(port/2), ceil(k/2)) = 0;
                    end
                    P(port, k+1) = P(port,k);
                    P(port+1, k+1) = P(port+1,k);
                else
                    % conflict
                    S(ceil(port/2), ceil(k/2)) = NaN;
                    P(port, k+1) = NaN;
                    P(port+1, k+1) = NaN;
                end       
            end


            % APPLY LINKS k
            if k+2 <= 2*n
                P(LINKS(port,ceil(k/2)), k+2) = P(port, k+1);
                P(LINKS(port+1,ceil(k/2)), k+2) = P(port+1, k+1);
            end
        end
        if ceil(k/2) <= width(LINKS)
            for port = [1:2:N]
                STEPS_APP(port,:) = STEPS(LINKS(port,ceil(k/2)),:);
                STEPS_APP(port+1,:) = STEPS(LINKS(port+1,ceil(k/2)),:);
            end
            STEPS = STEPS_APP;
        end
    end
end