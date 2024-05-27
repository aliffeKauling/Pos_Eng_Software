package Ordenacao;

public class DC {
	public static void quicksort(int v[], int esquerda, int direita) {
		int esq = esquerda;
		int dir = direita;
		int pivo = v[(esq + dir) / 2];
		int troca=v[esq];
		while (esq <= dir) {
		while (v[esq] < pivo) {
		esq = esq + 1;}
		while (v[dir] > pivo) {
		dir = dir - 1;}
		if (esq <= dir) {
		v[esq] = v[dir];
		v[dir] = troca;
		esq = esq + 1;
		dir = dir - 1;
		}
		}
		if (dir > esquerda)
		quicksort(v, esquerda, dir);
		if (esq < direita)
		quicksort(v, esq, direita);
	}
}
