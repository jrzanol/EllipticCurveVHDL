LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY ModMult IS
PORT(A, B: IN SIGNED(63 DOWNTO 0);
		XOUT: OUT SIGNED(63 DOWNTO 0));
END ModMult;

ARCHITECTURE arch OF ModMult IS
SIGNAL result: SIGNED(127 DOWNTO 0);
BEGIN
	result <= (A * B);
	XOUT <= result(63 DOWNTO 0) WHEN result < SIGNED(P) ELSE result(63 DOWNTO 0) - SIGNED(P);
END arch;

