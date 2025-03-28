LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY ModNeg IS
PORT(X1: IN SIGNED (63 DOWNTO 0);
		XOUT: OUT SIGNED (63 DOWNTO 0));
END ModNeg;

ARCHITECTURE arch OF ModNeg IS
BEGIN
	XOUT <= (((NOT X1) + 1) + SIGNED(P));
END arch;

