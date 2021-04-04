% Question 5 | All parts for all codes, excluding the c) discussion and the
% answer to question asked in latter part of b)

% Sub-part a) and b) for all the three codewords will be done
% simultaneously. For each code, encoding, and the various descriptions in
% a) and b) as described, will all, be done in this single code.

% Once we obtain results we will attempt to:
% 1. Answer the question asked in b) (the latter part, the code results
% will be obtained here itself)
% 2. Discuss the results, as asked, in c)

% All comments have been removed since in the check section their
% explanatory purpose has been fulfilled, and this makes navigating code
% easier


% The pmf will remain same, and, constant, for all sequences





seq1 = [1 3 1 2 3 2 1 2];          % u1

seq2 = [1 3 1 2 3 2 1 3];          % u2

seq3 = [1 3 1 2 3 2 2 2];          % u3

seq_cell = cell(1,3);

seq_cell{1,1} = seq1;
seq_cell{1,2} = seq2;
seq_cell{1,3} = seq3;

for ite = 1:3
    
    seq = seq_cell{1,ite};
    pmf = [0.5 0.3 0.2];          % stays same for all       

    D = 2;

    r = size(pmf,2);              
    M = size(seq,2);              
    f = zeros(1,r);

    for i = 2:r
        f(1,i) = sum(pmf(1,1:i-1),2);
    end



    p = 1;
    F = 0;

    for k = 1:M
        obs = seq(1,k);
        F = F + p*f(1,obs);                   
        p = p*pmf(1,obs);
    end

    len = ceil((log(1/p))/(log(D))) + 1;                              % We assume binary codeword length is needed, obviously

    F_whole_dec = F;   

    max_length = 100;

    F_vec_bin = zeros(1,max_length);               



    if F >= 1
        disp('Some error in algorithm, making untruncated F in decimal greater than or equal to 1')
        flag = 1;
    elseif F > 0       
        length_flag = 0;
        flag = 2;
        for j = 1:100
            F = 2*F;
            if F < 1
                F_vec_bin(1,j) = 0;
            elseif F > 1
                F_vec_bin(1,j) = 1;
                F = F - 1;
            else
                disp('The binary representation of untruncated decimal codeword has length, post-decimal point, less than or equal to 100')
                F_vec_bin(1,j) = 1;
                if j ~= 100
                    disp('The length is less than 100, of the representation')
                    F_vec_bin(1,j+1) = NaN;    
                    length_flag = 1;
                else
                    disp('The length is exactly 100')
                    length_flag = 2;
                end
                break
            end
        end
    else
        flag = 0;
    end



    if flag == 1
        disp('Some weird error')
    elseif flag == 0

        F_bin = 0;                                   

        if len > 100
            F_bin_trunc = zeros(1,len);             
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = to_add + F_bin_trunc;      
        else
            F_bin_trunc = F_vec_bin(1,1:len);        
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = to_add + F_bin_trunc;      
        end

    else

        if (length_flag == 0 && len > 100)

            F_bin = F_vec_bin;
            disp('Representation incomplete due to maximum length = 100 assumption. The best representation, with this assumption is still displayed')
            F_bin_trunc = zeros(1,len);
            F_bin_trunc(1,1:100) = F_vec_bin(1,1:100);
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');

        elseif (length_flag == 0 && len <= 100)

            F_bin = F_vec_bin;
            F_bin_trunc = F_vec_bin(1,1:len);
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');




        elseif (length_flag == 1)   

            [max_val_red,term_indx] = max(isnan(F_vec_bin));
            F_bin = F_vec_bin(1,1:(term_indx-1));
            F_bin_trunc = F_bin(1,1:len);        
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');

        else

            F_bin = F_vec_bin;             
            F_bin_trunc = F_bin(1,1:len);
            to_add = zeros(1,len);
            to_add(1,len) = 1;
            F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');

        end



    end

    if flag ~= 1
        len_dec = ceil((log(1/p))/(log(10))) + 1;
        F_trunc_dec_interim = F_whole_dec*(10^len_dec);
        F_trunc_dec = floor(F_trunc_dec_interim);
        F_extr_trunc_dec_interim = F_whole_dec*(10^(len_dec-1));
        F_extr_trunc_dec = floor(F_extr_trunc_dec_interim);
        F_final_dec = (F_trunc_dec*(10^-len_dec) + (10^-len_dec))*(10^len_dec);
        F_final_dec = cast(F_final_dec,'int32');
        F_trunc_dec = cast(F_trunc_dec,'int32');
        F_extr_trunc_dec = cast(F_extr_trunc_dec,'int32');
    end


    if flag == 1
        disp('There is nothing to be displayed')
    else
        format long
        disp('The results for SEQUENCE:')
        disp(ite)
        disp('The various results, with corresponding cases and explanations in the comments of the code, go thus:')
        disp('The codeword length in binary is:')
        disp(len)
        disp('The codeword length in decimal, base 10 is:')
        disp(len_dec)
        disp('The code word, untruncated, in decimal is:')
        disp(F_whole_dec)
        disp('The code word, truncated, in decimal, without adding 2^-1 term, is:')
        disp(F_trunc_dec)
        disp('The code word, truncated, in decimal, with the addition of 2^-l (D^-l actually, 10^-l here, since D = 10) term, is:')
        disp(F_final_dec)
        disp('The code word, truncated to the l-1 length (smaller representation), in decimal, obviously without any term addition, is:')
        disp(F_extr_trunc_dec)
        disp('The code word, untruncated, in binary is:')
        disp(F_bin)
        disp('The code word, truncated, in binary is:')
        disp(F_bin_trunc)
        disp('The final code word, in binary, post addition of 2^-l term, is:')
        disp(F_bin_final)

        disp('NOTE : Decimal representations are converted to codewords after removing the decimal point, only exception is for the true, untruncated, whole, decimal representation')
    end
    
end























