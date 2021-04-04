% Huffman Block Coding for IID Binary RV's

% CASES: p = 0.35, p' = 0.05

% BLOCK LENGTH = M = 1,2,3

% GENERATE RANDOM SEQUENCES OF VARIABLE n

% ENCODE, CALCULATE AVERAGE CODE LENGTH PER BINARY SYMBOL

% AVERAGE OVER 20-40 REALIZATIONS OF BINARY SEQUENCES

% COMPARE TO ENTROPY BOUND

% DISCUSS RESULTS

% We assume we are performing Huffman Binary Coding


M_vec = [1 2 3];

p_vec = [0.35 0.05];                    % probability of 1, as such, in both cases

n_vec = [6 12 18 24 30 36 42 48 54 60];

% What will be n values?

% M=1, n=6,12,18,24,30,36,42,48,54,60
% M=2, n=6,12,18,24,30,36,42,48,54,60
% M=3, n=6,12,18,24,30,36,42,48,54,60

% Once a value of M and p selected, we know n range, and for each n value,
% the trial will be performed 30 times (between 20 to 40, 30 chosen)



% Huffman Coding has been done, a priori, by hand, and will be utilized
% directly here using input to code dictionary

% Coding from scratch for Huffman, in MATLAB, could've been done, however,
% it seemed time consuming despite being simple. Thus Coding done on paper,
% and here we will use those dictionaries directly.


%-------------------------------------------------------------------------

% p = 0.35

% M = 1

% input                    huffman code
% 0 -----------------------    0
% 1 -----------------------    1

% M = 2
   
% input                    huffman code
% 00 --------------------      0
% 01 --------------------      10
% 10 --------------------      110
% 11 --------------------      111

% M = 3

% input                    huffman code
% 000 --------------------    00                  
% 000 --------------------    010
% 010 --------------------    011
% 010 --------------------    100
% 101 --------------------    110
% 101 --------------------    111
% 111 --------------------    1010
% 111 --------------------    1011


%------------------------------------------------------------------------

% p' = 0.05

% M = 1

% input                    huffman code
% 0 -----------------------  0
% 1 -----------------------  1

% M = 2
   
% input                    huffman code
% 00 --------------------    0
% 01 --------------------    10
% 10 --------------------    110
% 11 --------------------    111

% M = 3

% input                    huffman code
% 000 --------------------   0                  
% 000 --------------------   100
% 010 --------------------   101
% 010 --------------------   110
% 101 --------------------   11100
% 101 --------------------   11101
% 111 --------------------   11110
% 111 --------------------   11111

%-------------------------------------------------------------------------

% Encoding and obtaining the required quantities

p1_1 = [0 1;
        1 1];

p1_2 = [0 1; 
        1 2;
        2 3;
        3 3];
    
p1_3 = [0 2;
        1 3;
        2 3;
        3 3;
        4 3;
        5 3;
        6 4;
        7 4];
    
    
    
p2_1 = p1_1;

p2_2 = p1_2;

p2_3 = [0 1;
        1 3;
        2 3;
        3 3;
        4 5;
        5 5;
        6 5;
        7 5];


dict_cell = cell(2,3);

dict_cell{1,1} = p1_1;
dict_cell{1,2} = p1_2;
dict_cell{1,3} = p1_3;

dict_cell{2,1} = p2_1;
dict_cell{2,2} = p2_2;
dict_cell{2,3} = p2_3;


for i = 1:2
    p = p_vec(1,i);
    H = (-p*log(p)-(1-p)*log(1-p))/log(2);
    for j = 1:3
        M = j;
        vec_len = zeros(1,10);
        for k = 1:10
            n = 6*k;
            len_ovrl = 0;
            for r = 1:30
                seq = rand(1,n);
                seq = (seq <= p);
                pieces = n/M;
                tot_len = 0;
                for t = 1:pieces
                    strt = 1+(t-1)*M;
                    ed = strt + M - 1;
                    foc = seq(1,strt:ed);
                    dec = bi2de(foc,'left-msb');
                    loc_dict = dict_cell{i,j};
                    code_len = loc_dict(dec+1,2);
                    tot_len = tot_len + code_len;
                end
                len_ovrl = len_ovrl + tot_len;
            end
            avrg_len = len_ovrl/30;
            avrg_len_sym = avrg_len/n;
            vec_len(1,k) = avrg_len_sym;
        end
        disp('The p value is')
        disp(p)
        disp('The M value is')
        disp(M)
        disp('The entropy rate or entropy currently for the p value is')
        disp(H)
        disp('For n = 6,12,..,60 we obtain the length per symbol vector as follows (for each n, this is the averaged value of 30 repeats)')
        disp(vec_len)
    end
end






























