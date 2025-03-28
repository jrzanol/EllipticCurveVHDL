LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY AddOnePoint IS
PORT(CLK, RST, START: IN STD_LOGIC;
		X1, Y1: IN SIGNED (63 DOWNTO 0);
		XOUT, YOUT: OUT SIGNED (63 DOWNTO 0);
		DONE: OUT STD_LOGIC);
END AddOnePoint;

ARCHITECTURE arch OF AddOnePoint IS
SIGNAL X2, Y2, deltaX, deltaY: SIGNED (63 DOWNTO 0);
SIGNAL lambda, lambda2: SIGNED (63 DOWNTO 0);
SIGNAL tmpX, tmpX2, tmpY, tmpY2, tmpY3: SIGNED (63 DOWNTO 0);
SIGNAL invDeltaX: UNSIGNED (63 DOWNTO 0);
SIGNAL modInvDone: STD_LOGIC;
BEGIN
	-- Chave Pública da Chave Privada=1.
	X2 <= SIGNED(Gx);
	Y2 <= SIGNED(Gy);
	
	-- Fórmula: Soma de Dois Pontos.
	-- L = (y2 - y1) / (x2 - x1)
	-- x = L^2 - x1 - x2
	-- y = L*(x1 - x) - y1
	
	MODINV_VAL: ModInv PORT MAP(CLK, RST, START, UNSIGNED(deltaX), UNSIGNED(P), modInvDone, invDeltaX);
	
	SUBDELTAX: ModSub PORT MAP(X2, X1, deltaX);
	SUBDELTAY: ModSub PORT MAP(Y2, Y1, deltaY);
	MULTLAMBDA: ModMult PORT MAP(deltaY, SIGNED(invDeltaX), lambda);
	MULTLAMBDA2: ModMult PORT MAP(lambda, lambda, lambda2);

	SUBLAMBDAX1: ModSub PORT MAP(lambda2, X1, tmpX);
	SUBLAMBDAX2: ModSub PORT MAP(tmpX, X2, tmpX2);
	SUBLAMBDAY1: ModSub PORT MAP(X1, tmpX2, tmpY);
	MULTLAMBDAY: ModMult PORT MAP(lambda, tmpY, tmpY2);
	SUBLAMBDAY2: ModSub PORT MAP(tmpY2, Y1, tmpY3);
	
	XOUT <= tmpX2;
	YOUT <= tmpY3;
	DONE <= modInvDone;
END arch;

