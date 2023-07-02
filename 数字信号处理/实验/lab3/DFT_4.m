function y=DFT_4(x)
    n=0:3;
    y(1)=sum(x);
    y(2)=x*exp(-1j*pi/2*n).';
    y(3)=x*exp(-1j*pi*n).';
    y(4)=x*exp(-1j*pi*3/2*n).';
end