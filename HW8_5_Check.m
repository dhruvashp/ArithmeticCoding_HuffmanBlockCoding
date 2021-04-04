% Question 5, Check

% Design binary arithmetic code for ternary random variable

% We will code to encode a single sequence (given in Moser) to check code
% correctness before we perform the tasks underlying the problem


% Block Length, M = Sequence length to be encoded

% U = {a,b,c} ternary RV, alpha_1 = a
%                         alpha_2 = b
%                         alpha_3 = c

% P = {p_a,p_b,p_c}    ,  p_a = p_alpha_1 = 0.5
%                         p_b = p_alpha_2 = 0.3
%                         p_c = p_alpha_3 = 0.2

% The above PMF and ordering is as given in Moser Example

% a ------- alpha_1 ------- 1           (representation)
% b ------- alpha_2 ------- 2           (representation)
% c ------- alpha_3 ------- 3           (representation)

% M will be decided from the sequence length, which is to be encoded
% U and PMF given
% Thus encoding algorithm given in Moser can be performed



% NOTE
% We will consider the sequence to be described in terms of 1,2 and 3's
% instead of a, b and c's. We could write extra code to convert the a, b
% and c's into 1,2 and 3's but this is trivial, and seems unnecessary. Thus
% a sequence such as abcca will correspond to input 12331, and we will
% presume that this is the input the code will be given, to further encode
% it.


% sequence given in Moser = baabcabbba = 2112312221

seq = [2 1 1 2 3 1 2 2 2 1];

pmf = [0.5 0.3 0.2];          % pmf as given in Moser example

D = 2;

% Additional Note
% U = {a,b,c} = {alpha_1,alpha_2,alpha_3}
% pmf = {P(alpha_1),P(alpha_2),P(alpha_3)} = {P(a),P(b),P(c)} 
%                                          = {0.5,0.3,0.2}

% Also note a,b,c and 1,2,3 are one and the same

% Arrangement of a,b,c to alpha's doesn't matter, but once fixed, should
% stay consistent to ensure algorithm sanity

% Note : r in alpha_1, alpha_2,....,alpha_r here is equal to 3
% r = 3

% alpha_1 = a = 1
% alpha_2 = b = 2
% alpha_3 = c = 3

r = size(pmf,2);              % alphabet size = non-zero probabilities given

M = size(seq,2);              % Block length = sequence length here

f = zeros(1,r);

for i = 2:r
    f(1,i) = sum(pmf(1,1:i-1),2);
end

% pmf = {p(alpha_1),p(alpha_2),p(alpha_3)}
% f = {f(alpha_1),f(alpha_2),f(alpha_3)}
% f(alpha_1) = 0
% f(alpha_c) = sum pmf entries from 1 to c-1, c > 1
% Since we know that f(alpha_r) = sum p(alpha_i) over i = 1 to r-1, r > 1


p = 1;
F = 0;

for k = 1:M
    obs = seq(1,k);
    F = F + p*f(1,obs);                   % since observation obs = z corresponds to alpha_z, at the zth or the obs position
    p = p*pmf(1,obs);
end

% F has F_M and p has p_M

len = ceil((log(1/p))/(log(D))) + 1;

F_whole_dec = F;   % entirety of F, in decimal, untruncated

max_length = 100;

F_vec_bin = zeros(1,max_length);                 % Two things assumed, 1. The length l, or len here, is <= 100 and 
                                                 %                     2. The natural description length of F_whole_dec in binary is also <= 100 (post-decimal point) 

                                          

% F_vec_bin is a row vector which contains the post-decimal point binary representation of the F_whole_dec value
% We assume that the scope of this exercise is not general, and, the limit
% of 100 on the maximum description length of the binary representation of
% F_whole_dec is more than sufficient.

% To code a more general case, with a possibly lengthy code, much, much
% lengthy, one could create a different data structure in MATLAB, one that
% doesn't require size to be initiated, and then append onto that
% structure. We can then, after a certain length, end the conversion
% program if the length exceeds beyond a certain length, length that is
% application based.


% Thus in our assumption both natural binary description length and length
% obtained must be <= 100. This can be changed based on application by
% changing the max_length here, thus we can argue that the code is general
% enough for the current exercise purpose.
                                          
% Converting F_whole_dec into binary now

% Note F_whole_dec will contain the actual untruncated decimal value, while
% F which till this point is equal to F_whole_dec, will be used and
% modified to obtain its binary representation

% Note : Naturally, F >= 0

if F >= 1
    disp('Some error in algorithm, making untruncated F in decimal greater than or equal to 1')
    flag = 1;
elseif F > 0       % F_whole_dec is in (0,1). We now convert this in binary. Note F and F_whole_dec are equal
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
                F_vec_bin(1,j+1) = NaN;    % to represent termination
                length_flag = 1;
            else
                disp('The length is exactly 100')
                length_flag = 2;
            end
            break
        end
    end
else
    % Implies F = 0 (or F_whole_dec = 0)
    % F_vec_bin stays filled with zeros, no change
    flag = 0;
end



% CASES

% flag = 1
% some error, F >= 1, we have a weird situation

% flag = 0
% F = 0. Thus F_vec_bin stays zero, which is correct

% flag = 2
% F is in (0,1)
%      length_flag = 0
%            implies that full binary representation has length > 100
%      length_flag = 1
%            implies this representation is of length < 100 
%            ending bit comes before NaN in our F_vec_bin
%      length_flag = 2
%            implies the representation has length exactly 100

% NOTE :
% F_whole_dec contains now the untruncated decimal representation of our
% codeword as F may have been modified to obtain the binary representation
% in this case


if flag == 1
    disp('Some weird error')
elseif flag == 0
    
    F_bin = 0;                                   % F_whole_decimal is zero in this case, thus binary representation is zero
    
    if len > 100
        F_bin_trunc = zeros(1,len);              % truncated binary code
        to_add = zeros(1,len);
        to_add(1,len) = 1;
        F_bin_final = to_add + F_bin_trunc;      % direct addition works since F_bin_trunc is as is completely 0
    else
        F_bin_trunc = F_vec_bin(1,1:len);        % as is, since flag is 0, F_vec_bin is filled with zeros only
        to_add = zeros(1,len);
        to_add(1,len) = 1;
        F_bin_final = to_add + F_bin_trunc;      % direct possible due to F_bin_trunc being null, note things here from the previous case are similar
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
    
        
    % For complete representations within length 100 (including 100) of the
    % binary code, we presume that the system is stable and thus len in
    % that case will be equal to or smaller than the total representational
    % length of the binary code obtained from the untruncated decimal code
        
    elseif (length_flag == 1)   
        
        [max_val_red,term_indx] = max(isnan(F_vec_bin));
        F_bin = F_vec_bin(1,1:(term_indx-1));
        F_bin_trunc = F_bin(1,1:len);         % stable system, full representation, len will be within bounds, assumed
        to_add = zeros(1,len);
        to_add(1,len) = 1;
        F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');
        
    else
        
        % length_flag is 2
        
        F_bin = F_vec_bin;             % actual representation ends exactly at 100, again stability assumed
        F_bin_trunc = F_bin(1,1:len);
        to_add = zeros(1,len);
        to_add(1,len) = 1;
        F_bin_final = de2bi(bi2de(F_bin_trunc,'left-msb')+bi2de(to_add,'left-msb'),'left-msb');
    
    end
        
        
        
end


if flag == 1
    disp('There is nothing to be displayed')
else
    format long
    disp('The various results, with corresponding cases and explanations in the comments of the code, go thus')
    disp('The code word, untruncated, in decimal is:')
    disp(F_whole_dec)
    disp('The code word, untruncated, in binary is:')
    disp(F_bin)
    disp('The code word, truncated, in binary is:')
    disp(F_bin_trunc)
    disp('The final code word, in binary, post addition of 2^-l term, is:')
    disp(F_bin_final)
end






















