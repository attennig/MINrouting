classdef MINetwork < handle
    properties
        n
        N
        LINKS
        S
        P
    end
    methods
        function Net = MINetwork(n)
            Net.n = n;
            Net.N = 2^n;
        end
        function [] = selfRouting(B, out_perm) 

            in_perm = [0:B.N-1];
            STEPS = dec2bin(out_perm);
            B.S = ones(B.N/2, B.n)*2;
            B.P = [in_perm' zeros(B.N, 2*B.n-1)];
            for k = [1:2:2*B.n]
                for port = [1:2:B.N]
                    % APPLY STEPS
                    if STEPS([port:port+1],ceil(k/2)) == ['1';'0']
                        % cross
                        if ~isnan(B.P(port,k))
                            B.S(ceil(port/2), ceil(k/2)) = 1;
                        end
                        B.P(port, k+1) = B.P(port+1,k);
                        B.P(port+1, k+1) = B.P(port,k);
                        app = STEPS(port,:);
                        STEPS(port,:) = STEPS(port+1,:);
                        STEPS(port+1,:) = app;
                    else
                        if STEPS([port:port+1],ceil(k/2)) == ['0';'1']
                            % straight
                            if ~isnan(B.P(port,k))
                                B.S(ceil(port/2), ceil(k/2)) = 0;
                            end
                            B.P(port, k+1) = B.P(port,k);
                            B.P(port+1, k+1) = B.P(port+1,k);
                        else
                            % conflict
                            if ceil(k/2) == 1 | (~isnan(B.S(ceil(port/2), ceil(k/2)-1)))
                                B.S(ceil(port/2), ceil(k/2)) = NaN;
                                B.P(port, k+1) = NaN;
                                B.P(port+1, k+1) = NaN;
                            end
                        end       
                    end


                    % APPLY LINKS k
                    if k+2 <= 2*B.n
                        B.P(B.LINKS(port,ceil(k/2)), k+2) = B.P(port, k+1);
                        B.P(B.LINKS(port+1,ceil(k/2)), k+2) = B.P(port+1, k+1);
                    end
                end
                if ceil(k/2) <= width(B.LINKS)
                    for port = [1:2:B.N]
                        STEPS_APP(port,:) = STEPS(B.LINKS(port,ceil(k/2)),:);
                        STEPS_APP(port+1,:) = STEPS(B.LINKS(port+1,ceil(k/2)),:);
                    end
                    STEPS = STEPS_APP;
                end
            end
        end
        
        function [] = draw(B)
            figure;
            for stage = [1:B.n]
                for sw = [1:B.N/2]
                    if B.S(sw,stage) == 1
                        %cross
                        plot(stage,B.N/2-sw+1,'o', 'MarkerFaceColor', 'b');
                    else
                        if B.S(sw,stage) == 0
                            %straight
                            plot(stage,B.N/2-sw+1,'o', 'MarkerFaceColor','g');
                        else
                            if B.S(sw,stage) == 2
                                plot(stage,B.N/2-sw+1,'o', 'MarkerFaceColor',[0.5,0.5,0.5]);
                            else
                                plot(stage,B.N/2-sw+1,'o','MarkerFaceColor','r');
                            end
                        end
                    end        
                    hold on;
                end
            end
            
            for stage = [1:B.n-1]
                for sw = [1:B.N/2]
                    p_out1 = sw*2-1;
                    p_out2 = sw*2;
                    p_in1 = B.LINKS(p_out1, stage);
                    p_in2 = B.LINKS(p_out2, stage);
                    sw_out1 = ceil(p_in1/2);
                    sw_out2 = ceil(p_in2/2);
                    plot([stage, stage+1], [sw, sw_out1], 'k');
                    hold on;
                    plot([stage, stage+1], [sw, sw_out2], 'k');
                    hold on;
                end
            end
            
            axis off; 
        end
            
    end
end