# CUDA_somador_de_vetores
Somador de vetores utilizando CUDA

## Descrição
Este projeto implementa a soma de dois vetores utilizando a tecnologia CUDA, aproveitando a capacidade de processamento paralelo das GPUs.

## Requisitos
- CUDA Toolkit instalado
- NVIDIA GPU compatível com CUDA

## Executar no Windows

1. Compile o código CUDA usando o seguinte comando:

    ```bash
    nvcc -gencode arch=compute_50,code=sm_50 -o somador vector_add_cuda.cu
    ```

    **Observação**: Os valores para `arch` e `code` podem variar dependendo da sua GPU. O exemplo acima é configurado para a arquitetura `compute_50` (Maxwell). Você pode precisar ajustar essas opções para sua configuração específica:

    - Para verificar qual arquitetura é compatível com sua GPU, consulte a [tabela de arquiteturas CUDA](https://developer.nvidia.com/cuda-gpus).
    - Exemplos de diferentes valores:
        - Para uma arquitetura `compute_35` (Kepler): `-gencode arch=compute_35,code=sm_35`
        - Para uma arquitetura `compute_60` (Pascal): `-gencode arch=compute_60,code=sm_60`
  
2. Após a compilação, execute o programa gerado:

    ```bash
    ./somador
    ```

## Executar no Linux
1. Instalação dos drivers da Nvidia (xx = versão compativel)
```
    sudo apt install nvidia-utils-xx
```
2. Realizar a instalação do CUDA compativel com a GPU
```bash
    sudo apt update
    sudo apt install nvidia-cuda-toolkit
```
Verificar versão do CUDA instalado:
```
    nvcc --version
```
3. Compile o código CUDA usando o seguinte comando:
```
    nvcc -o somador vector_add_cuda.cu
```
4. Após a compilação, execute o programa gerado:
```
    ./somador
```

## Como funciona
Este código realiza a soma de dois vetores de forma paralela utilizando as capacidades da GPU. Ele pode ser adaptado para trabalhar com vetores de diferentes tamanhos e tipos de dados.
