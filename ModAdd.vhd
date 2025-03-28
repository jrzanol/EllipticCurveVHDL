LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY ModAdd IS
PORT(X1, X2: IN SIGNED (63 DOWNTO 0);
		XOUT: OUT SIGNED (63 DOWNTO 0));
END ModAdd;

ARCHITECTURE arch OF ModAdd IS
SIGNAL Xtmp: SIGNED (63 DOWNTO 0);
BEGIN
	Xtmp <= (X1 + X2);
	XOUT <= Xtmp WHEN X1 < SIGNED(P) ELSE (Xtmp - SIGNED(P));
END arch;

