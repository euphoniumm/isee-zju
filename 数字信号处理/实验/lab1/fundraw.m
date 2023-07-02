function fundraw(n,x)%函数名fundraw，以及输入参数为序列长度以及序列函数
    subplot(2,2,1);%实部
    stem(n,real(x));
    title('real part');
 
    subplot(2,2,2);%虚部
    stem(n,imag(x));
	title('imaginary part');

    subplot(2,2,3);%模
    stem(n,abs(x));
    title('magnitude part');
 
    subplot(2,2,4);%相角
    stem(n,angle(x));
    title('phase part');
end