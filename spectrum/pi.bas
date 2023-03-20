CLS
DIM D as ubyte
DIM Q,R,T,K,N,L,QT,RT,TT,KT AS Ulong
D=0
Q=1:R=0:T=1:K=1:N=3:L=3
WHILE D<18
IF 4*Q+R-T<N*T
    PRINT N;" ";
    IF D=0 THEN PRINT ".";
    D=D+1
    QT=Q
    Q=10*Q
    RT=R
    R=10*(R-N*T)
    N=(10*(3*QT+RT)/T)-10*N
ELSE
    QT=Q
    Q=Q*K
    RT=R
    R=(2*QT+R)*L
    TT=T
    T=T*L
    KT=K
    K=K+1
    N=(QT*(7*KT+2)+RT*L)/(TT*L)
    L=L+2
ENDIF
WEND
PRINT
PRINT "PI in spectrum !!"
PAUSE 1000