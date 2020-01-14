function [ B ] = get_B (T,nu)
top_B = (nu^3)*1.191e-8;
bottom_B = exp(1.439*nu/T) - 1;

B = top_B/bottom_B;
end