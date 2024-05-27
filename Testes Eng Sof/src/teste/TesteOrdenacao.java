package teste;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import Ordenacao.DC;

class TesteOrdenacao {

	@Test
	void test1() {
		int vetor1[]= {0,3,4,6,8,15,65,65,76,89,100};
		int vetor2[]= {0,100,15,65,65,76,3,4,6,8,89};
		
		DC.quicksort(vetor2,0, vetor2.length - 1);
		for (int i = 0; i < vetor1.length; i++) {
		assertEquals(vetor1[i], vetor2[i]);
		}	
	}
	
	@Test
	void test2() {
		int vetor1[]= {0,3,4,6,8,15,65,65,76,89,100};
		int vetor2[]= {0,3,4,6,8,15,65,65,76,89,100};
		for (int i = 0; i < vetor1.length; i++) {
		assertEquals(vetor1[i], vetor2[i]);
		}	
	}


}
