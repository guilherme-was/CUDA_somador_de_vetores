#include <iostream>
#include <cuda_runtime.h>

// Função de verificação de erro CUDA
inline void checkCudaError(const char* msg) {
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << msg << " - " << cudaGetErrorString(err) << std::endl;
        exit(-1);
    }
}

__global__ void vectorAdd(int *a, int *b, int *c, int N) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < N) {
        c[index] = a[index] + b[index];
    }
}

int main() {
    int N = 10000;  // Tamanho dos vetores
    int *a, *b, *c;  // Vetores de entrada e saída
    int *d_a, *d_b, *d_c;  // Ponteiros para a memória da GPU

    // Aloca memória para os vetores no host
    a = new int[N];
    b = new int[N];
    c = new int[N];

    // Inicializa os vetores
    for (int i = 0; i < N; ++i) {
        a[i] = i;
        b[i] = i * 2;
    }

    // Aloca memória na GPU
    cudaMalloc(&d_a, N * sizeof(int));
    checkCudaError("Erro ao alocar memória para d_a");

    cudaMalloc(&d_b, N * sizeof(int));
    checkCudaError("Erro ao alocar memória para d_b");

    cudaMalloc(&d_c, N * sizeof(int));
    checkCudaError("Erro ao alocar memória para d_c");

    // Copia os dados dos vetores para a memória da GPU
    cudaMemcpy(d_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    checkCudaError("Erro ao copiar dados para d_a");

    cudaMemcpy(d_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
    checkCudaError("Erro ao copiar dados para d_b");

    // Define o número de threads por bloco e o número de blocos
    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

    // Chama o kernel CUDA
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, N);
    checkCudaError("Erro ao lançar o kernel");

    // Copia o resultado de volta para a memória do host
    cudaMemcpy(c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    checkCudaError("Erro ao copiar dados de volta para c");

    // Imprime todos os valores de a, b e c
	std::cout << "Valores sendo somados e o resultado (a + b = c):" << std::endl;
	for (int i = 0; i < N; ++i) {
		std::cout << "a[" << i << "] = " << a[i] << " + b[" << i << "] = " << b[i] << " => c[" << i << "] = " << c[i] << std::endl;
	}


    // Verifica o resultado
    for (int i = 0; i < N; ++i) {
        if (c[i] != a[i] + b[i]) {
            std::cout << "Erro no calculo! Indice: " << i << std::endl;
            break;
        }
    }

    // Libera a memória
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    delete[] a;
    delete[] b;
    delete[] c;

    std::cout << "Somador de vetores concluido!" << std::endl;

    return 0;
}
